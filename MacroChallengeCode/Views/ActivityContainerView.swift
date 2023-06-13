//
//  ActivityContainerView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 09/06/23.
//

import SwiftUI
import CoreLocation
import SunKit


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return formatter
}()

struct ActivityContainerView: View {
    
    @Binding var pathsJSON : [PathCustom]
    @Binding var userLocation : CLLocation?
    @StateObject var path : PathCustom = PathCustom(title: "\(Date().description)")
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    var ns: Namespace.ID
    
    
    
    
    
    @State var start = Date()
    
    @State var magnitude : Double = 100.0

    var body: some View {
        let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: userLocation!, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: userLocation!, timeZone: TimeZone.current).sunset)) ?? 21)
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        GeometryReader{ geo in
            ZStack{
                Color(day.hours[currentHour].color).opacity(0.7).ignoresSafeArea()
                
                switch activity {
                case .map:
                    ShowPathView(pathsJSON: $pathsJSON, userLocation: $userLocation, path: path, mapScreen: $mapScreen,activity: $activity, screen: $screen, ns: ns, magnitude: $magnitude, day : day)
                        
                    BoxSliderView(magnitude: $magnitude)
                        .frame(width: geo.size.width * 0.1, height: geo.size.width * 0.2).position(x: geo.size.width * 0.9, y: geo.size.height * 0.2)
                        .foregroundColor( Color(day.hours[currentHour].color).opacity(0.7))
                case .sunset:
                    CircularSliderView(pathsJSON: $pathsJSON, path: path, userLocation: $userLocation, sunset: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunset, start: start, screen: $screen,activity: $activity, mapScreen: $mapScreen, namespace: ns, day : day)
                        .padding(70)
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
                    VStack{
                        Text("Stop Activity")
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
                            
                    }.background(){
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color("white"))
                        }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
                
                SwitchModeButton(imageName: (activity == .map) ? "sunset.fill" : "globe" , color: day.hours[currentHour].color, activity: $activity
                ).frame(width: geo.size.width * 0.1, height: geo.size.width * 0.1)
                    .position(x: geo.size.width * 0.9, y: geo.size.height * 0.1)
            }
        }
    }
}


struct ActivityContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityContainerView(pathsJSON: .constant([]), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), path: PathCustom(title: "Hello"), screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.trackBack), ns: Namespace.init().wrappedValue)
    }
}
