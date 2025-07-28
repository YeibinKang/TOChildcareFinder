//
//  MapView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-17.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    
    @ObservedObject var dataManager:DataManager
    @ObservedObject var locationManager:LocationManager
    @State private var selectedCentre: ChildCareCentre? = nil
    @State private var showDetail = false
    @State var searchText: String = ""
    
    
    //@State var selectedSupports:
    @State var showListSheet:Bool = true
    
    var body: some View {
        
        
        
        VStack{
            
            ZStack(alignment: .bottom){
                if !dataManager.centres.isEmpty {
                    Map(position: $locationManager.position){
                        
                        ForEach(dataManager.centres){ centre in
                            
                            Annotation(centre.name, coordinate: CLLocationCoordinate2D(latitude: centre.latitude, longitude: centre.longitude)){
                                VStack {
                                    Image(systemName: "mappin.and.ellipse.circle.fill")
                                        .font(.title)
                                        .foregroundColor(.orange)
                                        .onTapGesture {
                                            selectedCentre = centre
                                            showDetail = true
                                        }
                                    
                                }
                            }
                            
                        }
                        
                        UserAnnotation()
                        
                    }
                    .mapControls{
                        MapUserLocationButton()
                    }
                    .frame(height:300)
                    .sheet(item: $selectedCentre){ centre in
                        ChildCareSheetView(centre: centre)
                            .environmentObject(dataManager)
                        
                    }
                }
                
                VStack{
                    //search bar
                    SearchBar(text: $searchText)
                        .padding(.top, 10)
                    
                    //filter
                }
                
            }
            .sheet(isPresented: $showListSheet){
                BottomListSheet()
                    .presentationDetents([.fraction(0.1), .fraction(0.4), .large])
                    .presentationDragIndicator(.visible)
                    .environmentObject(dataManager)
            }
            
            
            
            
            
        }
        
        
    }
    
}


