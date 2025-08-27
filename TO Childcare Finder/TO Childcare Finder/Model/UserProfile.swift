//
//  UserProfile.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-08-21.
//

import Foundation
import FirebaseFirestore

struct UserProfile: Identifiable, Codable{
    @DocumentID var id: String?
    var displayName: String?
    var email: String
    var role: String
    @ServerTimestamp var createdAt: Date?
    
    var reviewCount: Int?
    var waitlistCount: Int?

}

enum UserRole: String, Codable {
    case caregiver
    case admin
}
