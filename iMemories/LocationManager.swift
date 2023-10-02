//
//  LocationManager.swift
//  iMemories
//
//  Created by Davron Abdukhakimov on 01/10/23.
//

import Foundation
import CoreLocation
class LocationManager:NSObject,ObservableObject, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager?
    @Published var location:CLLocationCoordinate2D?
    
    
    func checkIfLocationServicesEnabled(){
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            
        }
        
        
    }
    func checkLocationAuthorization(){
        guard let locationManager = locationManager else {
            return
        }
        switch locationManager.authorizationStatus{
        case .authorizedWhenInUse:
            
            
            locationManager.requestLocation()
            location = locationManager.location?.coordinate
            
            
            // Location services are available.
            // Insert code here of what should happen when Location services are authorized
            break
        case .authorizedAlways:
            
            locationManager.requestLocation()
            location = locationManager.location?.coordinate
            
            
        case .restricted:
            // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            
            break
            
        case .denied:
            
            // Location services currently unavailable.
            // Insert code here of what should happen when Location services are NOT authorized
            
            break
            
        case .notDetermined:
            // Authorization not determined yet.
            locationManager.requestWhenInUseAuthorization()
            break
            
        @unknown default:
            break
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
}


