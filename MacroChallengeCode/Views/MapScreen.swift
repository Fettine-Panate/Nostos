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
    var path : PathCustom = PathCustom()
    @State private var gyroRotation = 0.0
    private let motionManager = CMMotionManager()
    
    
    var body: some View {
        
        //TODO: da fare su una posizione statica (quella dell'utente
        ZStack{
//            CurrentPositionView()
//                .rotationEffect(.degrees(gyroRotation), anchor: .center)
//                .animation(.easeInOut, value: gyroRotation)
            MapBackground()
            IndicatorView()
                .rotationEffect(.degrees(gyroRotation), anchor: .center)
                .animation(.easeInOut, value: gyroRotation)
                .onAppear {
                    startGyroscopeUpdates()
                    // updateUserLocation()
                }
                .onDisappear {
                    stopGyroscopeUpdates()
                }
                // Used to see if my idea were correct
            
            VStack{
                Spacer()
                Text("\(userLocation.coordinate.latitude) and \(userLocation.coordinate.longitude)")
                    .onAppear{
                        path.addLocation(userLocation, checkLocation: path.checkDistance)
                    }
                    .onChange(of: userLocation) { newValue in
                        path.addLocation(newValue, checkLocation: path.checkDistance)
                        print("New Print!\n \(path.getLocations())\n\n ")
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
