//
//  ContentView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-07.
//

import SwiftUI



struct ContentView: View {
    
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var locationManager = LocationManager()
    
    var body: some View {
        TabView {
            
            
            MapView(dataManager: dataManager, locationManager:locationManager)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            ListView(dataManager: _dataManager)
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
            
            FavouritesView()
                .tabItem {
                    Label("Favourites", systemImage: "star")
                }
        }
        .onAppear{
            dataManager.load()
        }
    }
    
}




#Preview {
    ContentView()
}
