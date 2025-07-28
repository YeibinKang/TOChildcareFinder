//
//  FilterTagView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-16.
//

import SwiftUI

struct FilterTagView: View {
    
    let items: [String]
    @Binding var selectedFilters: Set<String>
    
    
    var body: some View {
        
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        LazyVGrid(columns: columns, alignment: .leading, spacing: 10){
            ForEach(items, id:\.self){ item in
                let isSelected = selectedFilters.contains(item)
                
                FilterTagButton(item: item, isSelected: isSelected, toggle:{
                    if isSelected {
                        selectedFilters.remove(item)
                    } else {
                        selectedFilters.insert(item)
                    }
                })
                

                
            }
        }
        
        
    }
}

