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
                //MapBackground()
                MapView(path: path, currentUserLocation: userLocation)
                
                //IndicatorView()
                VStack{
                    Spacer()
                    Text("\(userLocation.coordinate.latitude) and \(userLocation.coordinate.longitude)")
                        .onAppear(){
                            path.addLocation(userLocation, checkLocation: {_,_ in 
                                return true
                            })
                        }
                        .onChange(of: userLocation) { loc in
                            path.addLocation(loc, checkLocation: path.checkDistance)
                        }
                    NavigationLink(destination: {PinsMapView(path: path, currentUserLocation: userLocation)}, label: {Text("Mappa con pin")})
                    
                    VStack{
                        NavigationLink(destination: {TrackBackView(currentUserLocation: userLocation, path: path)}, label: {Text("Torna indietro").foregroundColor(.red)})
                    }
                }
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