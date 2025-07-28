//
//  CallButton.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-22.
//

import SwiftUI

struct CallButton: View {
    
    let phoneNumber: String
    var label:String = "Call"
    var color:Color = .green
    
    func removeOtherCharacters(_ rawNumber: String) -> String {
        let digits = rawNumber.filter{"0123456789".contains($0)}
        return digits
    }
    
    
    var body: some View {
        
        let cleanedNumber = removeOtherCharacters(phoneNumber)
        
        Button(action: {
            if let url = URL(string: "tel://\(cleanedNumber)"),
               UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            }
        }){
            Label(label, systemImage: "phone.fill")
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
                .frame(height: 20)
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        
    }
}


