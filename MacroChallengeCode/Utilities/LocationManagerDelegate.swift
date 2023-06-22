//
//  LocationManagerDelegate.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 22/05/23.
//

import Foundation
import CoreLocation
import MapKit


class LocationManager: NSObject, ObservableObject {
    
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.837034, longitude: 14.306127), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    private let manager = CLLocationManager()
    @Published var userLocation : CLLocation?
    static let shared = LocationManager()
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.startUpdatingLocation()
        manager.allowsBackgroundLocationUpdates = false
        manager.showsBackgroundLocationIndicator = true
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func startLocationUpdates(){
        manager.allowsBackgroundLocationUpdates = true
    }
    
    func stopLocationUpdates(){
        manager.allowsBackgroundLocationUpdates = false
    }
  
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            print("DEBUG: notDetermined")
        case .restricted:
            print("DEBUG: restricted")
        case .denied:
            print("DEBUG: denied")
        case .authorizedAlways, .authorizedWhenInUse:
            print("DEBUG: authorizedAlways")
            region = MKCoordinateRegion(center: manager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        @unknown default:
            print("DEBUG: unknown")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.userLocation = location
    }
    
    
    func requestLocation(){
        manager.requestWhenInUseAuthorization()
    }
    
}

