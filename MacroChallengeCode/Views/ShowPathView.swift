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
    @Binding var activity: ActivityEnum
    @Binding var screen : Screens
    
    var ns: Namespace.ID
    
    @Binding var magnitude : Double 

    let day : dayFase
    
    var body: some View {
      
        
        GeometryReader{ geo in
     
            ZStack{
                
                Text(mapScreen == .mapView ? "Going.." : "ComingBack")
                .font(.title)
                .bold()
                .font(.title)
                .foregroundColor(Color("white"))
                .position(CGPoint(x: geo.size.width/2, y: geo.size.height * 0.8/10))
                
                switch mapScreen{
                case .mapView:
                    MapView(path: path, currentUserLocation: $userLocation, screen: $screen, mapScreen: $mapScreen, pathsJSON: $pathsJSON, ns: ns, magnitude: $magnitude, day : day)
                case .trackBack:
                    TrackBackView(currentUserLocation: $userLocation, previouspath: path, screen: $screen, activity: $activity, mapScreen: $mapScreen, ns: ns,  magnitude: $magnitude, day : day)
                }
              
                
            }
        }
        
    }
}

//struct ShowPathView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowPathView()
//    }
//}
