//
//  TrackBackView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 26/05/23.
//

import SwiftUI
import CoreLocation

struct TrackBackView: View {
    var currentUserLocation : CLLocation
    @StateObject var path : PathCustom
    @State var magnitude = 250.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(path.getLocations(), id: \.self ){ loc in
                    if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude){
                        let position = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude)
                        PinAnnotationView(loc: loc)
                            .position(position)
                            .animation(.linear, value: position)
                    }
                }.overlay{
                    ZStack{
                        Path { pat in
                            for (index, loc) in path.getLocations().enumerated() {
                                if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude){
                                    let point = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude)
                                    if index == 0 {
                                        pat.move(to: point)
                                    } else {
                                        pat.addLine(to: point)
                                    }
                                }
                            }
                        }
                        .stroke(Color.blue, lineWidth: 2)
                        .animation(.default)
                    }
                }
//                ZStack{
//                    Path { pat in
//                        for (index, loc) in path.getLocations().enumerated() {
//                            if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude){
//                                let point = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude)
//                                if index == 0 {
//                                    pat.move(to: point)
//                                } else {
//                                    pat.addLine(to: point)
//                                }
//                            }
//                        }
//                    }
//                    .stroke(Color.blue, lineWidth: 2)
//                    .animation(.default)
//                }
            }
        }
    }
}


//
//struct TrackBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackBackView(userLocation: <#CLLocation#>, path: <#PathCustom#>)
//    }
//}
