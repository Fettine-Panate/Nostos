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
    @ObservedObject var compassHeading = CompassHeading()
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    @State var magnitude = 250.0
    @State var scale = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.yellow
                    IndicatorView()
                    .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                    .scaleEffect(0.3)
                    .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                    ForEach(path.getLocations(), id: \.self ){ loc in
                        if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                            let position = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                            PinAnnotationView(loc: loc)
                                .position(position)
                                .animation(.linear, value: position)
                                .scaleEffect(scale / 3)
                        }
                    }
                    .overlay{
                        ZStack{
                            withAnimation{
                                Path { pat in
                                    for (index, loc) in path.getLocations().enumerated() {
                                        if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                                            let point = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                                            if index == 0 {
                                                pat.move(to: point)
                                            } else {
                                                pat.addLine(to: point)
                                            }
                                        }
                                    }
                                }
                                .stroke(Color.red, lineWidth: 2 * scale)
                                .scaleEffect(scale / 3)
                            }
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
            //.rotationEffect(Angle(degrees: self.compassHeading.degrees))
            .gesture(
                MagnificationGesture()
                    .updating($magnification) { value, magnification, _ in
                        magnification = value
                    }
                    .onChanged { value in
                        currentValue = value
                        magnitude = value * magnitudeinm
                        scale = 1/value
                    }
            )
        }
    }
}


func calculatePosition3(loc: CLLocation, currentLocation: CLLocation, sizeOfScreen: CGSize, latitudeMetersMax: CGFloat) -> CGPoint{
    
    let longPin = loc.coordinate.longitude
    let longUser = currentLocation.coordinate.longitude
    
    let latPin = loc.coordinate.latitude
    let latUser = currentLocation.coordinate.latitude
    
    let longDistance = (longPin - longUser)/degreesOnMeter
    
    let latDistance = (latPin - latUser)/degreesOnMeter
    
    let maxY = latitudeMetersMax
    let maxX = (maxY*sizeOfScreen.width)/sizeOfScreen.height
    
    let y = sizeOfScreen.height - (latDistance * sizeOfScreen.height)/maxY
    let x = sizeOfScreen.width/2 + (longDistance * sizeOfScreen.width)/maxX
    
    return CGPoint(x: x, y: y)
}




//
//struct TrackBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackBackView(userLocation: <#CLLocation#>, path: <#PathCustom#>)
//    }
//}
