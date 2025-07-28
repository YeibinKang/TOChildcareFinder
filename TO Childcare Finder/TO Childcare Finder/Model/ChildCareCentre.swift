//
//  ChildCareCentre.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-08.
//

import Foundation
import FirebaseFirestore


struct ChildCareCentre: Codable, Identifiable, Hashable{
    var id:Int
    var name:String
    var address:String
    var postalCode:String
    var phone:String
    var subsidy:Bool
    var cwelcc:Bool
    var infantSpace:Int
    var toddlerSpace:Int
    var preschoolSpace:Int
    var kindergartenSpace:Int
    var schoolAgeSpace:Int
    var totalSpace:Int
    var latitude:Double
    var longitude:Double
    
}

