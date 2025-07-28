//
//  FirebaseService.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-07.
//

import Foundation
import FirebaseFirestore

class FirebaseService: ObservableObject{
    @Published var centres: [ChildCareCentre] = []
    
    private var db = Firestore.firestore()
    

    func checkVersionUpdate(completion: @escaping (Bool, [ChildCareCentre]) -> Void){
        let localVersion = UserDefaults.standard.string(forKey: "dataVersion") ?? "0"
        
        db.collection("metadata").document("childcare_data").getDocument{ snapshot, error in
        
            //case1 - fail to get version
            guard let doc = snapshot,
                  let firebaseVersion = doc.data()?["version"] as? String else {
                print("Failed to get version information from Firebase")
                completion(false,[])
                return
            }
            
            //case2 - version should be updated
            if firebaseVersion != localVersion {
                print("New version detected. Fetching data...")
                self.fetchCentres{ centres in
                    if !centres.isEmpty {
                        if let encoded = try? JSONEncoder().encode(centres){
                            UserDefaults.standard.set(encoded, forKey: "childcare_centres")
                            UserDefaults.standard.set(firebaseVersion, forKey: "dataVersion")
                            
                        }
                        completion(true, centres)
                    }else{
                        completion(false, [])
                    }
                    
                }
            //case3 - version is already up-to-date
            }else{
                
                print("Data is up to date.")
                print("FirebaseDataVersion: " + (firebaseVersion) + " localVersion: " + localVersion)
                completion(false, [])
            }
            
        }
        
    }
    
    
    func fetchCentres(completion: @escaping ([ChildCareCentre]) -> Void){
        db.collection("childcare_centres").getDocuments { snapshot, error in
            if let error = error{
                print("Error getting documents: \(error)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else{
                print("No documents found")
                completion([])
                return
            }
            
            do{
                self.centres = try documents.map{
                    try $0.data(as: ChildCareCentre.self)
                   
                }
            
                completion(self.centres)
            }catch{
                print("Error decoding documents: \(error)")
                completion([])
            }
        }
    }
    
    
    
}
