//
//  ActivityContainerView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 09/06/23.
//

import SwiftUI
import CoreLocation
import SunKit

struct ActivityContainerView: View {
    
    @Binding var pathsJSON : [PathCustom]
    @Binding var userLocation : CLLocation?
    @ObservedObject var path : PathCustom
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
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

                switch activity {
                case .map:
                    ShowPathView(pathsJSON: $pathsJSON, userLocation: $userLocation, path: path, mapScreen: $mapScreen,activity: $activity, screen: $screen, _ns: ns)
                case .sunset:
                    CircularSliderView(sunset: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunset, start: .now, screen: $screen,activity: $activity, mapScreen: $mapScreen, namespace: ns)
                }
                
                Button {
                    withAnimation {
                        screen = .startView
                        //TODO: create a func to do this
                        mapScreen = .mapView
                        activity = .map
                        // TODO: Stop the activity
                        LiveActivityManager.shared.stopActivity()
                    }
                } label: {
                    Text("Stop activity")
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
                
                SwitchModeButton(imageName: (activity == .map) ? "sunset.fill" : "globe" , color: day.hours[currentHour].color, activity: $activity
                ).frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                    .position(x: geo.size.width * 0.9, y: geo.size.height * 0.2)
            }
        }
    }
}


struct ActivityContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityContainerView(pathsJSON: .constant([]), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), path: PathCustom(title: "Hello"), screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.trackBack), _ns: nil)
    }
}
