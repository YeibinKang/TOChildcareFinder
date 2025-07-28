//
//  index.js
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-07.
//

import { readFileSync } from 'fs';
import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';


//Firebase setup
const serviceAccount = JSON.parse(readFileSync('./firebase-admin-key.json'));
initializeApp({ credential: cert(serviceAccount) });
const db = getFirestore();

//Get GeoJSON
const rawGeoJSON = JSON.parse(readFileSync('./childcare.geojson'));

//Parsing data
const centres = rawGeoJSON.features.map((centre) => {
    const props = centre.properties;
    //const [lon, lat] = centre.geometry.coordinates;

    return {
        id: props.LOC_ID,
        name: props.LOC_NAME,
        address: props.ADDRESS,
        postalCode: props.PCODE,
        phone: props.PHONE,
        subsidy: props.subsidy === 'Y',
        cwelcc: props.cwelcc_flag === 'Y',
        infantSpace: props.IGSPACE,
        toddlerSpace: props.TGSPACE,
        preschoolSpace: props.PGSPACE,
        kindergartenSpace: props.KGSPACE,
        schoolAgeSpace: props.SGSPACE,
        totalSpace: props.TOTSPACE,
        latitude: centre.geometry.coordinates[0][1],
        longitude: centre.geometry.coordinates[0][0],
    };

});

//Upload to firebase
const uploadData = async () => {
    for (const centre of centres) {
        try {
            await db.collection('childcare_centres').doc(centre.id.toString()).set(centre);

        } catch (err) {
            console.error(`❌ Error uploading ${centre.name}:`, err);
        }
    }

    console.log('✅ All data uploaded to Firestore!');
};

const run = async () => {
    await uploadData();
};

run();
