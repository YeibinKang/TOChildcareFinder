//
//  LocalDataService.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-09.
//

import Foundation

class LocalDataService: ObservableObject{
    @Published var centres:[ChildCareCentre] = []
    
    //load data from UserDefaults
    func load(){
        //UserDedfaults -> JSON decoder
        if let data = UserDefaults.standard.data(forKey: "childcare_centres"){
            let decoded = try? JSONDecoder().decode([ChildCareCentre].self, from: data)
            self.centres = decoded ?? []
        }else{
            print("Failed to load data from UserDefaults")
        }
    }
}
