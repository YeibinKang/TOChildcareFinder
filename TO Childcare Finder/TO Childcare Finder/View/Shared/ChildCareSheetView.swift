//
//  ChildCareSheetView.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-18.
//

import SwiftUI
import MapKit

struct ChildCareSheetView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    let centre: ChildCareCentre
    
    var isFavourited: Bool {
        dataManager.favourites.contains(String(centre.id))
    }
    
    //computed property
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: centre.latitude, longitude: centre.longitude)
    }
    
    @State private var cameraPosition: MapCameraPosition
    @State private var zoom: Double = 0.05
    
    @State private var showCopiedAlert = false
    
    
    init(centre: ChildCareCentre) {
        self.centre = centre
        self._cameraPosition = State(initialValue:
                .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: centre.latitude, longitude: centre.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))
        )
    }
    
    
    func openGoogleSearch(for query:String){
        let base = "https://www.google.com/search?q="
        if let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: base + encodedQuery){
            UIApplication.shared.open(url)
        }
        
    }
    
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 16){
                
                
                //.padding([.top, .trailing])
                
                ZStack{
                    Map(position: $cameraPosition) {
                        Marker(centre.name, coordinate: location)
                    }
                    .frame(height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    
                    HStack{

                        Spacer()
                        VStack{
                            HStack(spacing:12){
                                
                                CircleIconButton(systemImageName: "arrow.backward"){
                                    dismiss()
                                }
                                
                                Spacer()
                                
                                CircleIconButton(systemImageName:"square.and.arrow.up"){
                                    let centreInfo = """
    \(centre.name)
    \(centre.address)
    Phone: \(centre.phone)
    """
                                    
                                    UIPasteboard.general.string = centreInfo
                                    showCopiedAlert = true
                                }
                                .accessibilityLabel("Copy centre info to clipboard")
                                .alert("Copied to clipboard!", isPresented: $showCopiedAlert) {
                                    Button("OK", role: .cancel) { }
                                } message: {
                                    Text("Saved to clipboard for easy sharing!")
                                }
                                
                               
                                CircleIconButton(systemImageName:isFavourited ? "heart.fill" : "heart"){
                                    dataManager.toggleFavourites(id: String(centre.id))
                                }
                                
                               
                            }
                            
                            
                            
                            Spacer()
                        }
                        .padding(.top, 12)
                        
                    }
                    
                }
                
                
                
                VStack(alignment: .leading, spacing:4){
                    Text(centre.name)
                        .font(.title)
                        .bold()
                    Text("\(centre.address)" + ", " + "\(centre.postalCode)")
                        .font(.subheadline)
                        .foregroundStyle(Color.gray)
                }
                .padding(.horizontal)
                
                Divider()
                
                //government support
                HStack(spacing:20){
                    
                    Label(centre.subsidy ? "Subsidy" : "No subsidy", systemImage: "dollarsign.circle")
                        .foregroundStyle(Color.green)
                        .fontWeight(.bold)
                    Label(centre.cwelcc ? "CWELCC" : "No CWELCC", systemImage: "checkmark.seal")
                        .foregroundStyle(Color.blue)
                        .fontWeight(.bold)
                }
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                //age groups
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack(spacing: 20) {
                        Label("Total: \(centre.totalSpace)", systemImage: "person.3")
                        
                    }
                    .font(.subheadline)
                    .fontWeight(.bold)
                    
                    HStack(spacing: 10) {
                        
                        AgeTagView(title:"Infant: \(centre.infantSpace)", systemImage:"figure.and.child.holdinghands", color:Color.orange)
                        
                        AgeTagView(title: "Toddler: \(centre.toddlerSpace)", systemImage: "figure.walk", color: Color.yellow)
                        
                        AgeTagView(title: "Preschool: \(centre.preschoolSpace)", systemImage: "books.vertical", color: Color.mint.opacity(0.7))
                  
                        
                    }
                    .font(.subheadline)
                    HStack(spacing: 10) {

                        
                        AgeTagView(title: "Kindergarten: \(centre.kindergartenSpace)", systemImage: "building.columns", color: Color.blue.opacity(0.7))
                        
                        AgeTagView(title: "School Age: \(centre.schoolAgeSpace)", systemImage: "graduationcap", color: Color.purple.opacity(0.7))

                    }
                    .font(.subheadline)
                    
                }
                .padding(.horizontal)
                
                Divider()
                
                //call
                //website
                
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    HStack(spacing: 12) {
                        CallButton(phoneNumber: centre.phone)
                        
                        Button(action: {
                            openGoogleSearch(for: "\(centre.name)" + " " + "\(centre.address)")
                        }){
                            Label("Site", systemImage: "globe")
                                .foregroundColor(.white)
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                                .frame(maxWidth: .infinity)
                                .frame(height: 20)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                    
                    
                }
                
                
                
            }
        }
        .presentationDetents([.fraction(0.7), .large])
        
    }
}


