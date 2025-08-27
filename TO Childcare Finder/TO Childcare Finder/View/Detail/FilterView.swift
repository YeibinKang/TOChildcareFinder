//
//  FilterView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-16.
//

import SwiftUI

struct FilterView: View {
//    @Binding var selectedSupports: Set<String>
//    @Binding var selectedAgeGroups: Set<String>
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    let supportOptions = ["Subsidy", "CWELCC"]
    let ageGroupOptions = ["Infant", "Toddler", "Preschool", "Kindergarten", "School Age"]
    
    
    var body: some View {
        
        VStack(spacing:0){
            HStack{
                Button(action:{
                    dismiss()
                }){
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
                
                Text("Filter")
                    .font(.headline)
                
                Spacer()
                
                // placeholder for layout symmetry
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundColor(.clear)
                
            }
            .padding()
            
            VStack(spacing: 12) {
                sectionBox(title: "Goverment Support"){
                    FilterTagView(items: supportOptions, selectedFilters: $dataManager.selectedSupports)
                }
                
                sectionBox(title: "Age Group"){
                    FilterTagView(items: ageGroupOptions, selectedFilters: $dataManager.selectedAgeGroups)
                }
                
            }
            .padding(.top, 4)
            
            Spacer().frame(height:12)
            
            HStack {
                Button("Clear All Filters") {
                    dataManager.selectedSupports.removeAll()
                    dataManager.selectedAgeGroups.removeAll()
                }
                .padding()
                .frame(minWidth: 140)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(12)
                
                Spacer()
                
                Button("Apply Filters") {
                    dismiss()
                }
                .padding()
                .frame(minWidth: 140)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(.horizontal)
            .padding(.bottom, 6)
        }
        .background(Color(.systemGroupedBackground))
        
        
    }

    
    
    
    
    
    
}

@ViewBuilder
private func sectionBox<Content: View>(title: String, @ViewBuilder content:()->Content) -> some View{
    VStack(alignment: .leading, spacing: 12){
        Text(title)
            .font(.headline)
            .foregroundStyle(Color.primary)
        
        content()
    }
    .padding()
    .background(Color.white)
    .cornerRadius(16)
    .padding(.horizontal)
    
}


