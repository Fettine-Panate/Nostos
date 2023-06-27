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
        if defaults.integer(forKey: "ON_BOARDING") == nil || defaults.integer(forKey: "ON_BOARDING") < 5{
            defaults.set(0, forKey: "ON_BOARDING")
        }
       
    }
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
       
        
        ZStack{
            switch screen {
            case .startView:
                StartView(pathsJSON: $pathsJSON, screen: $screen, ns: ns, resumeLastPath: $resumeLastPath)
            case .activity:
                if(LocationManager.shared.isRequestBeingDone()){
                    ActivityContainerView(pathsJSON: $pathsJSON, userLocation: $locationManager.userLocation, screen: $screen, activity: $activity, mapScreen: $mapScreen, ns: ns, resumeLastPath: $resumeLastPath)
                }else{
                    ActivateGPS(screen: $screen, mapScreen: $mapScreen, activity: $activity)
                }
            case .finished:
                if(LocationManager.shared.isRequestBeingDone()){
                    let day : DayPhase = DayPhase(sun: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current))
                    ArrivedBackView(screen: $screen, activity: $activity, mapScreen: $mapScreen, ns: ns, day: day)
                }else{
                    ActivateGPS(screen: $screen, mapScreen: $mapScreen, activity: $activity)
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
