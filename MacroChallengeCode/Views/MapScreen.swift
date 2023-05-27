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
    @StateObject var path = PathCustom()
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
                            path.addLocation(userLocation, checkLocation: {_,_ in
                                return true
                            })
                        }.frame(height: 50).padding(.horizontal)
                        .onChange(of: userLocation) { loc in
                            if path.isComingBack() == false {
                                path.addLocation(loc, checkLocation: path.checkDistance)
                            } else {
                                //path.removeCheckpoint()
                            }
                        }
                    HStack{
                        NavigationLink(destination: {PinsMapView(path: path, currentUserLocation: userLocation)}, label: {
                            BoxNavigationButton(text: "Mappa con pin")
                        })
                        NavigationLink(destination: {
                            TrackBackView(currentUserLocation: userLocation, path: path)
                        }, label: {
                            BoxNavigationButton(text: "Torna indietro")
                        }).onTapGesture {
                            path.setComingBack(comingBack: true)
                        }
                    }.frame(height: 100).padding(.horizontal)
                }
            }.onAppear(){
                path.setComingBack(comingBack: false)
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
        MapScreen(userLocation: CLLocation())
    }
}
