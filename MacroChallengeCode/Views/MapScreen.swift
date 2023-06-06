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
    @Binding var pathsJSON : [PathCustom]
    @StateObject var path = PathCustom(title: "\(Date().description)")
    @State private var gyroRotation = 0.0
    private let motionManager = CMMotionManager()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    let day : dayFase  = dayFase(sunrise: 06, sunset: 21)
    
    
    var body: some View {
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        NavigationStack{
            ZStack{
                Color(day.hours[currentHour].color).opacity(0.7).ignoresSafeArea()
                MapView(path: path, currentUserLocation: userLocation)
                VStack{
                    Spacer()
                    BoxDataView(text: "Lat: \(userLocation.coordinate.latitude)\nLon: \(userLocation.coordinate.longitude)")
                        .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .accentColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .onAppear(){
                            path.addLocation(userLocation, checkLocation: path.checkDistance)
                        }.frame(height: 50).padding(.horizontal)
                        .onChange(of: userLocation) { loc in
                                path.addLocation(loc, checkLocation: path.checkDistance)
                            pathsJSON.removeLast()
                            pathsJSON.append(path)
                            savePack("Paths", pathsJSON)
                        }
                    HStack{
//                        NavigationLink(destination: {PinsMapView(path: path, currentUserLocation: userLocation)}, label: {
//                            BoxNavigationButton(text: "Mappa con pin")
//                        })
                        NavigationLink(destination: {
                            TrackBackView(currentUserLocation: userLocation, previouspath: path)
                        }, label: {
                            BoxNavigationButton(text: "Torna indietro")
                                .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
                        })
                    }.frame(height: 50).padding(.horizontal)
                }
            }.onAppear(){
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
        }
    }
    
    func startGyroscopeUpdates() {
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { gyroData, _ in
                if let rotationRate = gyroData?.rotationRate {
                    self.gyroRotation = rotationRate.z * 10
                }
            }
        }
    }
    
    func stopGyroscopeUpdates() {
        motionManager.stopGyroUpdates()
    }
}

struct MapScreen_Previews: PreviewProvider {
    static var previews: some View {
        MapScreen(userLocation: CLLocation(), pathsJSON: .constant([]))
    }
}
