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
    case finished
}

enum ActivityEnum {
    case map
    case sunset
}

enum MapSwitch {
    case mapView
    case trackBack
}

let defaults = UserDefaults.standard

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return formatter
}()

let dateFormatterHHMM: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()

struct ContentView: View {
    @State var pathsJSON = itemsJSON
    @State var changeScreen = 0
    @State var screen : Screens = .startView
    @State var activity : ActivityEnum = .map
    @State var mapScreen : MapSwitch = .mapView
    @Namespace var ns
    @State var resumeLastPath = false
    
    init(pathsJSON: [PathCustom] = itemsJSON, changeScreen: Int = 0, screen: Screens = .startView) {
        self.pathsJSON = pathsJSON
        self.changeScreen = changeScreen
        self.screen = screen
        if defaults.integer(forKey: "ON_BOARDING") == nil {
            defaults.set(0, forKey: "ON_BOARDING")
        }else if defaults.integer(forKey: "ON_BOARDING") < 5{
            defaults.set(0, forKey: "ON_BOARDING")
        }
        if defaults.bool(forKey: "IS_STARTED") == nil {
            defaults.set(false, forKey: "IS_STARTED")
        }
    }
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
       
        
        ZStack{
            switch screen {
            case .startView:
                StartView(pathsJSON: $pathsJSON, screen: $screen, ns: ns, resumeLastPath: $resumeLastPath)
            case .activity:
                if(LocationManager.shared.userLocation != nil){
                    ActivityContainerView(pathsJSON: $pathsJSON, userLocation: $locationManager.userLocation, screen: $screen, activity: $activity, mapScreen: $mapScreen, ns: ns, resumeLastPath: $resumeLastPath)
                }else{
                    //TODO schermata quando prova a iniziare senza accettare il gps
                    Text("Activate into your settings the GPS track")
                }
            case .finished:
                if(LocationManager.shared.userLocation != nil){
                    let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunset)) ?? 21)
                    ArrivedBackView(screen: $screen, activity: $activity, mapScreen: $mapScreen, ns: ns, day: day)
                }else{
                    //TODO schermata quando prova a iniziare senza accettare il gps
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
