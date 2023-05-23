//
//  ContentView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 19/05/23.
//

import SwiftUI
import MapKit
import CoreLocation



struct ContentView: View {
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        if locationManager.userLocation == nil {
            LocationRequestView()
        } else if let location = locationManager.userLocation {
            MapScreen(userLocation: location)
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
