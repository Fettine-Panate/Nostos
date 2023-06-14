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


enum Screens {
    case startView
    case activity
}

enum ActivityEnum {
    case map
    case sunset
    case finished
}

enum MapSwitch {
    case mapView
    case trackBack
}

let defaults = UserDefaults.standard

struct ContentView: View {
    @State var pathsJSON = itemsJSON
    @State var changeScreen = 0
    @State var screen : Screens = .startView
    @State var activity : ActivityEnum = .map
    @State var mapScreen : MapSwitch = .mapView
    @Namespace var ns
    
    init(pathsJSON: [PathCustom] = itemsJSON, changeScreen: Int = 0, screen: Screens = .startView) {
        self.pathsJSON = pathsJSON
        self.changeScreen = changeScreen
        self.screen = screen
        if defaults.integer(forKey: "ON_BOARDING") == nil {
            defaults.set(0, forKey: "ON_BOARDING")
        }
    }
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
        
        ZStack{
            switch screen {
            case .startView:
                StartView(pathsJSON: $pathsJSON, screen: $screen, ns: ns)
            case .activity:
                if(LocationManager.shared.userLocation != nil){
                    ActivityContainerView(pathsJSON: $pathsJSON, userLocation: $locationManager.userLocation, screen: $screen, activity: $activity, mapScreen: $mapScreen, ns: ns)
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
