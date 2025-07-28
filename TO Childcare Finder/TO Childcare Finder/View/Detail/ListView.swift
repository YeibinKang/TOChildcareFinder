//
//  ListView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-17.
//

import SwiftUI
import MapKit
import CoreLocation

struct ListView: View {
    
    @EnvironmentObject var dataManager: DataManager
    
    @State private var selectedCentre: ChildCareCentre? = nil
    @State private var showDetail = false
    @State private var showFilterSheet = false
    @State private var selectedSupports: Set<String> = []
    @State private var selectedAgeGroups: Set<String> = []
    
//    var filteredCentres: [ChildCareCentre]{
//        dataManager.centres.filter{ centre in
//            let matchesSupport: Bool = {
//                if selectedSupports.isEmpty {
//                    return true
//                }
//                if selectedSupports.contains("Subsidy") && !centre.subsidy {
//                    return false
//                }
//                if selectedSupports.contains("CWELCC") && !centre.cwelcc {
//                    return false
//                }
//                return true
//            }()
//            
//
//            let matchesAge: Bool = {
//                if selectedAgeGroups.isEmpty {
//                    return true
//                }
//                var match = false
//                if selectedAgeGroups.contains("Infant") && centre.infantSpace > 0 {
//                    match = true
//                }
//                if selectedAgeGroups.contains("Toddler") && centre.toddlerSpace > 0 {
//                    match = true
//                }
//                if selectedAgeGroups.contains("Preschool") && centre.preschoolSpace > 0 {
//                    match = true
//                }
//                if selectedAgeGroups.contains("Kindergarten") && centre.kindergartenSpace > 0 {
//                    match = true
//                }
//                if selectedAgeGroups.contains("School Age") && centre.schoolAgeSpace > 0 {
//                    match = true
//                }
//                return match
//            }()
//            
//            return matchesSupport && matchesAge
//        }
//    }
    
    private func rowView(for centre: ChildCareCentre) -> some View{
        HStack{
            VStack(alignment: .leading){
                
                Text(centre.name)
                    .font(.headline)
                
                HStack{
                    if centre.cwelcc{
                        
                        Text("CWELCC available").font(.subheadline).foregroundStyle(.green)
                    }
                    if centre.subsidy{
                        Text("Subsidy available").font(.subheadline).foregroundStyle(.blue)
                    }
                }
                
                
                Text(centre.address + ", " + centre.postalCode)
                Text(centre.phone)
                
                
            }
            
            Spacer()
            
            // favourite icon
            Image(systemName: dataManager.favourites.contains(String(centre.id)) ? "heart.fill" : "heart")
                .foregroundStyle(.red)
                .onTapGesture {
                    dataManager.toggleFavourites(id: String(centre.id))
                }
            
        }
        
    }
    
    
    var body: some View {
        

        
        NavigationStack {
            ZStack{
                VStack{
                    
                    
                    Button {
                        showFilterSheet = true
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                        Text("Filter")
                    }
                    .sheet(isPresented: $showFilterSheet){
                        FilterView()
                            .environmentObject(dataManager)
                            .presentationBackground(Color(.systemGroupedBackground))
                            .presentationDetents([.fraction(0.7)])
                            .presentationDragIndicator(.visible)
                    }
                    
                    
                    List(dataManager.filteredCentres) { centre in
                            rowView(for: centre)
                            .onTapGesture {
                                selectedCentre = centre
                                
                                    //showDetail = true
                              
                                
                            }
                        
                    }
                    .sheet(item: $selectedCentre){ centre in
                        ChildCareSheetView(centre: centre)
                            .environmentObject(dataManager)
                        
                    }

                    
                }
                
            }
            
            
        }
        
        
        
        
        
    }
}



