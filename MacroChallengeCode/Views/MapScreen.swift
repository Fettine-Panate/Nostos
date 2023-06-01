//
//  MapScreen.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import SwiftUI
import CoreLocation
import CoreMotion

struct MapScreen: View {
    var userLocation : CLLocation
    @Binding var pathsJSON : [PathCustom]
    @StateObject var path = PathCustom(title: "FINTO")
    @State private var gyroRotation = 0.0
    private let motionManager = CMMotionManager()
    
    
    var body: some View {
        NavigationStack{
            ZStack{
                MapView(path: path, currentUserLocation: userLocation)
                VStack{
                    Spacer()
                    //componente messo solo per vedere
//                    BoxHourView()
//                        .frame(height: 120)
//                        .padding(.horizontal)
                    //                    Text("\(userLocation.coordinate.latitude) and \(userLocation.coordinate.longitude)")
                    //                        .onAppear(){
                    //                            path.addLocation(userLocation, checkLocation: {_,_ in
                    //                                return true
                    //                            })
                    //                        }
                    //                        .onChange(of: userLocation) { loc in
                    //                            if path.isComingBack() == false {
                    //                                path.addLocation(loc, checkLocation: path.checkDistance)
                    //                            } else {
                    //                                //path.removeCheckpoint()
                    //                            }
                    //                        }
                    BoxDataView(text: "Lat: \(userLocation.coordinate.latitude)\nLon: \(userLocation.coordinate.longitude)")
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
                        NavigationLink(destination: {PinsMapView(path: path, currentUserLocation: userLocation)}, label: {
                            BoxNavigationButton(text: "Mappa con pin")
                        })
                        NavigationLink(destination: {
                            TrackBackView(currentUserLocation: userLocation, previouspath: path)
                        }, label: {
                            BoxNavigationButton(text: "Torna indietro")
                        })
                    }.frame(height: 100).padding(.horizontal)
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
