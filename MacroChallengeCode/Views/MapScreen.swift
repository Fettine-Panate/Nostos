//
//  MapScreen.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import SwiftUI
import CoreLocation
import CoreMotion
import SunKit

struct MapScreen: View {
    var userLocation : CLLocation
    @StateObject var path = PathCustom(title: "\(Date().description)")
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
    
    @Binding var screen : Screens
    
    var body: some View {
        let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: userLocation, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: userLocation, timeZone: TimeZone.current).sunset)) ?? 21)
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        NavigationStack{
            ZStack{
                Color(day.hours[currentHour].color).opacity(0.7).ignoresSafeArea()
                MapView(path: path, currentUserLocation: userLocation, screen: $screen, _ns: ns)
                
//                VStack{
//                    Spacer()
//                    BoxDataView(text: "Lat: \(userLocation.coordinate.latitude)\nLon: \(userLocation.coordinate.longitude)")
//                        .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
//                        .accentColor(Color(day.hours[currentHour].color).opacity(0.7))
//                        .onAppear(){
//                            path.addLocation(userLocation, checkLocation: path.checkDistance)
//                        }.frame(height: 50).padding(.horizontal)
//                        .onChange(of: userLocation) { loc in
//                                path.addLocation(loc, checkLocation: path.checkDistance)
//                            pathsJSON.removeLast()
//                            pathsJSON.append(path)
//                            savePack("Paths", pathsJSON)
//                        }
//                    HStack{
//                        NavigationLink(destination: {
//                            TrackBackView(currentUserLocation: userLocation, previouspath: path)
//                        }, label: {
//                            BoxNavigationButton(text: "Torna indietro")
//                                .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
//                        })
//                    }.frame(height: 50).padding(.horizontal)
//                }
            }.onAppear(){
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
        }
    }
    
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen(userLocation: CLLocation(), pathsJSON: .constant([]), _ns: nil, screen: .constant(.mapScreenView))
    }
}
