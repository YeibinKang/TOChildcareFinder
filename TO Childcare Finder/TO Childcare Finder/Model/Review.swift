//
//  Review.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-08-21.
//

import Foundation
import FirebaseFirestore

struct Review: Codable, Identifiable {
    @DocumentID var id: String?
    var centreId: String
    var userId: String
    var reviewTags: [ReviewTags]
    @ServerTimestamp var createdAt: Date?
    @ServerTimestamp var updatedAt: Date?
    
}

enum ReviewTags: String, Codable {
    case clean = "Clean facility"
    case friendly = "Friendly staff"
    case helpful = "Helpful information"
    case safe = "Safe environment"
    case shortWaitTime = "Short wait time"
    case responsive = "Responsive communication"
    case activityVariety = "Variety of activities"
    case mealVariety = "Variety of meals"
    case reasonablePrice = "Reasonable price"
    
    case messy = "Messy facility"
    case unfriendly = "Unfriendly staff"
    case lackOfInfo = "Lack of information"
    case unsafe = "Unsafe environment"
    case longWaitTime = "Long wait time"
    case unresponsive = "Unresponsive communication"
    case limitedActivityVariety = "Limited activities"
    case limitedMealVariety = "Limited meals"
    case excessivePrice = "Excessive price"
    
}
