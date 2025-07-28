//
//  AgeTagView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-23.
//

import SwiftUI

struct AgeTagView: View {
    
    let title: String
    let systemImage: String
    let color: Color
    
    var body: some View {
        Label(title, systemImage: systemImage)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.clear, lineWidth: 1)
                    .fill(color)
            )
    }
}

