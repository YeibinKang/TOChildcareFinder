//
//  SearchBar.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-23.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder:String = "Location or Address"
    @EnvironmentObject var dataManager: DataManager
    
    
    var body: some View {
        
        HStack{
            Button(action:{
                dataManager.searchText = text
                dataManager.applyFilters()
            }){
                Image(systemName: "magnifyingglass.circle.fill")
                    .foregroundStyle(.gray)
            }
            
            
            TextField(placeholder, text: $text)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)

            
            if !text.isEmpty{
                Button(action:{
                    text = ""
                    dataManager.searchText = ""
                    dataManager.applyFilters()
                }){
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
            }
        }
        .padding(8)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
        
    }
}


