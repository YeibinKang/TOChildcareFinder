//
//  LocationManager.swift
//  TO Childcare Finder
//
//  Created by Yeibin Kang on 2025-07-09.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate{
    private let locationManager = CLLocationManager()
    var hasSetInitialPosition: Bool = false
    
    @Published var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 43.6532, longitude: -79.3832), 
            span: MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
        )
    )
    
    
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else { return }

        
        if hasSetInitialPosition { return }

           let region = MKCoordinateRegion(
               center: location.coordinate,
               span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
           )

           DispatchQueue.main.async {
               self.position = .region(region)
               self.hasSetInitialPosition = true

           }
    }
    
    
    
}
