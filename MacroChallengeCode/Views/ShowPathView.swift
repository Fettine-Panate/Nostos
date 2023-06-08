//
//  ShowPathView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 06/06/23.
//

import SwiftUI
import CoreLocation
import CoreMotion
import SunKit

struct ShowPathView: View {
    @Binding var pathsJSON : [PathCustom]
    @Binding var userLocation : CLLocation?
    @ObservedObject var path : PathCustom
    @Binding var mapScreen : MapSwitch
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    @Binding var screen : Screens
    
    var ns: Namespace.ID {
        _ns ?? namespace
    }
    @Namespace var namespace
    let _ns: Namespace.ID?
    
    var body: some View {
        let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: userLocation!, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: userLocation!, timeZone: TimeZone.current).sunset)) ?? 21)
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        
        GeometryReader{ geo in
     
            ZStack{
                Color(day.hours[currentHour].color).opacity(0.7).ignoresSafeArea()
                switch mapScreen{
                case .mapView:
                    MapView(path: path, currentUserLocation: $userLocation, screen: $screen, mapScreen: $mapScreen, pathsJSON: $pathsJSON, _ns: ns)
                case .trackBack:
                    TrackBackView(currentUserLocation: $userLocation, previouspath: path, screen: $screen, mapScreen: $mapScreen, _ns: ns)
                }
                Button {
                    screen = .startView
                } label: {
                    Text("Stop activity")
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
                
                SwitchModeButton(imageName: (screen == .mapScreenView) ? "sunset.fill" : "globe" , color: day.hours[currentHour].color, screen: $screen)
                    .position(x: geo.size.width * 0.9, y: geo.size.height * 0.2)

            }
        }
        
    }
}

//struct ShowPathView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowPathView()
//    }
//}
