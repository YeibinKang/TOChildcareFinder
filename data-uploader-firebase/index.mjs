//
//  index.js
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-07.
//

import { readFileSync } from 'fs';
import { createHash } from 'crypto';
import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore, FieldValue } from 'firebase-admin/firestore';


// Configuration
const SERVICE_KEY_PATH = './firebase-admin-key.json';
const GEOJSON_PATH = './childcare.geojson';
const COLLECTION_NAME = 'childcare_centres';
const METADATA_COL = 'metadata';
const METADATA_ID = 'childcare_data';


const BATCH_SIZE = 400;
const DRY_RUN = !process.argv.includes('--apply');



//Firebase setup
const serviceAccount = JSON.parse(readFileSync(SERVICE_KEY_PATH));
initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();


// Load GEOJSON & VERSIONING
const rawGeoJSON = JSON.parse(readFileSync(GEOJSON_PATH));
const features = Array.isArray(rawGeoJSON.features) ? rawGeoJSON.features : [];


// A HASH for any change detection (for synchronization purpose)
const normalized = features
    .map(f => {
        const p = f?.properties ?? {};
        const g = f?.geometry ?? {};
        const coordsStr = Array.isArray(g.coordinates) ? JSON.stringify(g.coordinates).slice(0, 300) : null;

        return {
            LOC_ID: p.LOC_ID ?? null,
            LOC_NAME: p.LOC_NAME ?? null,
            ADDRESS: p.ADDRESS ?? null,
            PCODE: p.PCODE ?? null,
            PHONE: p.PHONE ?? null,
            IGSPACE: p.IGSPACE ?? 0,
            TGSPACE: p.TGSPACE ?? 0,
            PGSPACE: p.PGSPACE ?? 0,
            KGSPACE: p.KGSPACE ?? 0,
            SGSPACE: p.SGSPACE ?? 0,
            TOTSPACE: p.TOTSPACE ?? 0,
            subsidy: p.subsidy ?? 'N',
            cwelcc_flag: p.cwelcc_flag ?? 'N',
            coords: coordsStr,
        };
    })
    // After creating normalized arryay, sort it to ensure consistent order
    .sort((a, b) => String(a.LOC_ID).localeCompare(String(b.LOC_ID)));


const versionHash = createHash('md5')
    .update(JSON.stringify(normalized))
    .digest('hex')
    .slice(0, 8); // Shorten the hash for easier reading


// run_date parsing/formatting 
//example: 20AUG25 -> 2025-08-20
function parseCustomDate(dateStr) {

    if (!dateStr || dateStr.length !== 7) {
        return null;
    }

    // first 2 chars: day
    const day = dateStr.slice(0, 2);
    // next 3 chars: month abbreviation
    const monthAbbr = dateStr.slice(2, 5).toUpperCase();

    const monthMap = {
        JAN: '01', FEB: '02', MAR: '03', APR: '04',
        MAY: '05', JUN: '06', JUL: '07', AUG: '08',
        SEP: '09', OCT: '10', NOV: '11', DEC: '12'
    };
    const month = monthMap[monthAbbr] || '01'; // default to January
    // last 2 chars: year (assumed to be 2000+)
    const year = '20' + dateStr.slice(5, 7);

    const fullDateStr = `${year}-${month}-${day}`;
    return fullDateStr;
}

// getting the latest "run_date"
function extractMaxRunDate(fs) {

    const vals = fs
        .map(f => parseCustomDate(f?.properties?.run_date)) // create array of run_date values
        .filter(Boolean) // remove undefined/null/empty values
        .map(String); // convert all values to strings for consistent comparison
    if (vals.length === 0) return null;
    return vals.sort().pop(); // get the max value
}

const sourceRunDate = extractMaxRunDate(features);




function parseCentre(feature) {
    const p = feature.properties ?? {}; //centre properties
    const g = feature.geometry ?? {}; // centre geometry

    // coordinates parsing
    let lat = null, lng = null;

    try {
        if (g.type === 'MultiPoint' && Array.isArray(g.coordinates)) {
            const first = g.coordinates[0];
            if (Array.isArray(first)) {
                lng = first[0];
                lat = first[1];
            }
        } else if (Array.isArray(g.coordinates)) {
            const first = Array.isArray(g.coordinates[0] && g.coordinates[0][0]) ? g.coordinates[0][0] : g.coordinates[0];
            if (Array.isArray(first)) {
                lng = first[0];
                lat = first[1];
            }
        }
    } catch (err) {
        console.warn(`⚠️  Error parsing coordinates for ${p.LOC_NAME}:`, err);
    }

    return {
        externalId: p.LOC_ID,
        name: p.LOC_NAME,
        address: p.ADDRESS,
        postalCode: p.PCODE,
        phone: p.PHONE,
        subsidy: p.subsidy === 'Y',
        cwelcc: p.cwelcc_flag === 'Y',
        infantSpace: p.IGSPACE,
        toddlerSpace: p.TGSPACE,
        preschoolSpace: p.PGSPACE,
        kindergartenSpace: p.KGSPACE,
        schoolAgeSpace: p.SGSPACE,
        totalSpace: p.TOTSPACE,
        latitude: lat,
        longitude: lng,
    };
}


// Scan existing documents
// create a map - Mapping an index of existing documents by externalId
async function loadExistingIndex() {
    const snap = await db.collection(COLLECTION_NAME).get();
    const index = new Map();
    snap.forEach(doc => {
        const data = doc.data();
        if (data?.externalId) {
            index.set(String(data.externalId), doc.ref);
        } else if (data?.id) { // 혹시 과거에 id 필드로 저장한 적이 있다면
            index.set(String(data.id), doc.ref);
        } else if (/^\d+$/.test(doc.id)) { // 과거 doc.id가 LOC_ID였던 경우
            index.set(String(doc.id), doc.ref);
        }
    });
    return index;
}


async function upsertAll(fs) {
    const existing = await loadExistingIndex();

    let touched = 0, created = 0, updated = 0, skipped = 0;
    let batch = db.batch(); // 여러 쓰기를 묶어서 한 번에 커밋하기 위한 배치 객체

    for (const f of fs) {
        const centre = parseCentre(f); // centre 객체 파싱

        if (!centre.externalId) {     //externalId 없으면 skip
            skipped++;
            continue;
        }
        centre.externalId = String(centre.externalId);

        const ref = existing.get(centre.externalId); //externalId로 기존 문서 ref 있는지 조회

        if (ref) { // 아미 존재하는 경우
            touched++;
            updated++;
            batch.set(ref, centre, { merge: true }); // 부분 병합 업데이트 (upsert)
        } else { // 없으면, 생성
            touched++;
            created++;
            const newRef = db.collection(COLLECTION_NAME).doc(); // 새 문서 랜덤 id 생성 (자동))
            batch.set(                                     // 새 문서 write 예약
                newRef,
                { ...centre, createdAt: FieldValue.serverTimestamp() }, // 생성 시점 기록(서버 시간)
                { merge: true }                            // merge지만 문서가 없으니 사실상 insert와 동일
            );
            existing.set(centre.externalId, newRef); // 새로 생성한 문서도 existing 맵에 추가
        }

        if (!DRY_RUN && touched % BATCH_SIZE === 0) {  // 드라이런이 아니고, 배치 크기 임계치에 도달하면
            await batch.commit();                        // 지금까지 예약된 쓰기들을 커밋(배치 하나 완료)
            console.log(`✅ Committed ${touched} docs so far…`);
            batch = db.batch();                          // 새 배치 시작
        }


    }
    if (!DRY_RUN) {
        await batch.commit();
    }

    return { touched, created, updated, skipped };



}



async function updateMetadata(version, runDate) {
    const ref = db.collection(METADATA_COL).doc(METADATA_ID);
    const payload = {
        version,                 // 해시 (예: 'a3b92c1f')
        sourceRunDate: runDate || null, // 예: '20AUG25'
        updatedAt: FieldValue.serverTimestamp(),
        source: 'Toronto Open Data (GeoJSON)',
    };
    if (DRY_RUN) {
        console.log('ℹ️ [DRY_RUN] Would update metadata:', payload);
        return;
    }
    await ref.set(payload, { merge: true });
}

async function cleanupLegacyFields() {
    const snap = await db.collection(COLLECTION_NAME).get();
    let batch = db.batch();
    let touched = 0, setExt = 0, removedId = 0;

    for (const doc of snap.docs) {
        const data = doc.data() || {};
        const updates = {};

        // externalId 없으면 채우기 (id나 doc.id에서)
        if (!data.externalId) {
            updates.externalId = String(data.id ?? doc.id);
            setExt++;
        }
        // 예전 id 필드는 삭제
        if (Object.prototype.hasOwnProperty.call(data, 'id')) {
            updates.id = FieldValue.delete();
            removedId++;
        }

        if (Object.keys(updates).length) {
            batch.update(doc.ref, updates);
            touched++;
            if (!DRY_RUN && touched % BATCH_SIZE === 0) {
                await batch.commit(); batch = db.batch();
            }
        }
    }
    if (!DRY_RUN) await batch.commit();
    console.log(`🧹 cleanup done. touched=${touched}, externalId set=${setExt}, legacy id removed=${removedId}`);
}


// ----------------- Run -------------------
console.log(`Found ${features.length} features. Version: ${versionHash}, sourceRunDate: ${sourceRunDate ?? '-'}`);
console.log(DRY_RUN ? 'Mode: DRY RUN (no writes)' : 'Mode: APPLY (writes enabled)');

try {
    const { touched, created, updated, skipped } = await upsertAll(features);
    console.log('— Upsert summary —');
    console.log(`touched: ${touched}, created: ${created}, updated: ${updated}, skipped: ${skipped}`);

    await updateMetadata(versionHash, sourceRunDate);
    await cleanupLegacyFields();
    console.log('🎉 Done.');
} catch (e) {
    console.error('❌ Failed:', e);
    process.exitCode = 1;
}




// //Parsing data
// const centres = rawGeoJSON.features.map((centre) => {
//     const props = centre.properties;
//     //const [lon, lat] = centre.geometry.coordinates;

//     return {
//         externalId: props.LOC_ID,
//         name: props.LOC_NAME,
//         address: props.ADDRESS,
//         postalCode: props.PCODE,
//         phone: props.PHONE,
//         subsidy: props.subsidy === 'Y',
//         cwelcc: props.cwelcc_flag === 'Y',
//         infantSpace: props.IGSPACE,
//         toddlerSpace: props.TGSPACE,
//         preschoolSpace: props.PGSPACE,
//         kindergartenSpace: props.KGSPACE,
//         schoolAgeSpace: props.SGSPACE,
//         totalSpace: props.TOTSPACE,
//         latitude: centre.geometry.coordinates[0][1],
//         longitude: centre.geometry.coordinates[0][0],
//     };

// });

// //Upload to firebase
// const uploadData = async () => {
//     for (const centre of centres) {
//         try {
//             await db.collection('childcare_centres').add(centre);

//         } catch (err) {
//             console.error(`❌ Error uploading ${centre.name}:`, err);
//         }
//     }

//     console.log('✅ All data uploaded to Firestore!');
// };

// const run = async () => {
//     await uploadData();
// };

// run();
