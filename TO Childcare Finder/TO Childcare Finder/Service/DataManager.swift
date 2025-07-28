//
//  DataManager.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-09.
//

import Foundation

class DataManager: ObservableObject{
    
    @Published var centres: [ChildCareCentre] = []
    @Published var filteredCentres: [ChildCareCentre] = []
    @Published var favourites:Set<String> = []{
        didSet{
            saveFavouriteToUserDefaults()
        }
    }
    
    @Published var searchText: String = ""
    @Published var selectedSupports: Set<String> = []
    @Published var selectedAgeGroups: Set<String> = []
    
    
    private let localService = LocalDataService()
    private let firebaseService = FirebaseService()
    
    init(){
        loadFavouritesFromUserDefaults()
    }
    
    func load(){
        //local
        localService.load()
        self.centres = localService.centres
        
        //firebase
        firebaseService.checkVersionUpdate{ updated, newData in
            if updated{
                DispatchQueue.main.async {
                    self.centres = newData
                }
            }
            
        }
    }
    
    
    func toggleFavourites(id: String){
        if(favourites.contains(id)){
            favourites.remove(id)
        }else{
            favourites.insert(id)
        }
        
        
        saveFavouriteToUserDefaults()
    }
    
    
    func saveFavouriteToUserDefaults(){
        UserDefaults.standard.set(Array(favourites), forKey: "favourites")
    }
    
    func loadFavouritesFromUserDefaults(){
        if let savedArray = UserDefaults.standard.array(forKey: "favourites") as? [String] {
            favourites = Set(savedArray)
        } else {
            favourites = []
        }
    }
    
    func applyFilters(){
        var results = centres
        
        if !searchText.isEmpty{
            results = results.filter{$0.name.localizedCaseInsensitiveContains(searchText)}
        }
        
        if !selectedSupports.isEmpty{
            results = results.filter{ centre in
                var matches = true
                if selectedSupports.contains("Subsidy") {
                    matches = matches && centre.subsidy
                }
                if selectedSupports.contains("CWELCC") {
                    matches = matches && centre.cwelcc
                }
                return matches
            }
        }
        
        if !selectedAgeGroups.isEmpty {
            results = results.filter { centre in
                var hasMatch = false
                
                if selectedAgeGroups.contains("infant") && centre.infantSpace > 0 {
                    hasMatch = true
                }
                if selectedAgeGroups.contains("toddler") && centre.toddlerSpace > 0 {
                    hasMatch = true
                }
                if selectedAgeGroups.contains("preschool") && centre.preschoolSpace > 0 {
                    hasMatch = true
                }
                if selectedAgeGroups.contains("kindergarten") && centre.kindergartenSpace > 0 {
                    hasMatch = true
                }
                if selectedAgeGroups.contains("schoolAge") && centre.schoolAgeSpace > 0 {
                    hasMatch = true
                }
                
                return hasMatch
                
            }
            
           
        }
        
        filteredCentres = results
        print(results.count)
    }
}
