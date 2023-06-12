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
    
    var ns: Namespace.ID {
        _ns ?? namespace
    }
    @Namespace var namespace
    let _ns: Namespace.ID?
    @Binding var magnitude : Double 

    
    var body: some View {
      
        
        GeometryReader{ geo in
     
            ZStack{
                switch mapScreen{
                case .mapView:
                    MapView(path: path, currentUserLocation: $userLocation, screen: $screen, mapScreen: $mapScreen, pathsJSON: $pathsJSON, _ns: ns, magnitude: $magnitude)
                case .trackBack:
                    TrackBackView(currentUserLocation: $userLocation, previouspath: path, screen: $screen, mapScreen: $mapScreen, _ns: ns,  magnitude: $magnitude)
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
