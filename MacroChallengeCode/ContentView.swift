//
//  ContentView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 19/05/23.
//

import SwiftUI
import MapKit
import CoreLocation
import SunKit


enum Screens: Equatable {
    case startView
    case circularSliderView
    case mapScreenView
  //Todo: per fare il bottone per cambiare activity
    // case activity
}

struct ContentView: View {
    @State var pathsJSON = itemsJSON
    @State var changeScreen = 0
    @State var screen : Screens = .startView
    @State var mapScreen : MapSwitch = .mapView
    @Namespace var ns
    @StateObject var path : PathCustom = PathCustom(title: "\(Date().description)")
    init(pathsJSON: [PathCustom] = itemsJSON, changeScreen: Int = 0, screen: Screens = .startView) {
        self.pathsJSON = pathsJSON
        self.changeScreen = changeScreen
        self.screen = screen
    }
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        
        ZStack{
            switch screen {
            case .startView:
                StartView(pathsJSON: $pathsJSON, screen: $screen, _ns: ns)
            case .circularSliderView:
                if(LocationManager.shared.userLocation != nil){
                    CircularSliderView(sunset: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunset, start: .now, screen: $screen, namespace: ns)
                }else{
                    Text("Activate into your settings the GPS track")
                }
            case .mapScreenView:
                if(LocationManager.shared.userLocation != nil){
                    
                    ShowPathView(pathsJSON: $pathsJSON, userLocation: $locationManager.userLocation, path: path, mapScreen: $mapScreen, screen: $screen,_ns: ns)
                }else{
                    Text("Activate into your settings the GPS track")
                }
            }
  
        }
        .onAppear{
            if(LocationManager.shared.userLocation == nil){
                LocationManager.shared.requestLocation()
                NotificationManager.shared.requestAuthorization()
            }
        }
    }
        
}






struct ContentView_Previews: PreviewProvider {
    
 
    static var previews: some View {
        ContentView()
    }
}
