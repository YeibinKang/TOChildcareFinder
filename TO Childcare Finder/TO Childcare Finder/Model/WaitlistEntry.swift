//
//  WaitlistEntry.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-08-22.
//

import Foundation
import FirebaseFirestore

struct WaitlistEntry: Codable, Identifiable{
    @DocumentID var id: String?
    var userId: String
    var centreId: String
    var status: Status
    var registrationMethod: RegistrationMethod
    var note: String?
    @ServerTimestamp var appliedAt: Date?
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    
}

enum Status: String, Codable{
    case planned = "To call"
    case applied = "Waitlisted"
    case completed = "Enrolled"
    case cancelled = "Cancelled"
}

enum RegistrationMethod: String, Codable{
    case phone
    case website
    case email
    case visit
}
