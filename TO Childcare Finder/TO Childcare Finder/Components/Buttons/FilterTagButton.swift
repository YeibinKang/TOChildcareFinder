//
//  FilterTagButton.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-17.
//

import SwiftUI

struct FilterTagButton: View {
    
    let item: String
    let isSelected: Bool
    let toggle:()->Void
    
    var body: some View {
        Button(action: toggle) {
                    Text(item)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(isSelected ? Color.orange : Color.gray.opacity(0.2))
                        .foregroundColor(isSelected ? .white : .primary)
                        .cornerRadius(16)
                }
                .buttonStyle(.plain)
                .contentShape(Rectangle()) // 터치 정확성 향상
            }
    }

