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
                        if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude){
                            let position = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, longitudeMetersMax: magnitude)
                            PinAnnotationView(loc: loc)
                                .position(position)
                                .animation(.linear, value: position)
                                .scaleEffect(scale)
                        }
                    }
                    .overlay{
                        ZStack{
                            withAnimation{
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
                                .stroke(Color.red, lineWidth: 2 * scale)
                                .scaleEffect(scale)
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
                    .padding(.bottom,geometry.size.height * 0.4)
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
                        scale = value
                    }
            )
        }
    }
}


func calculatePosition3(loc: CLLocation, currentLocation: CLLocation, sizeOfScreen: CGSize, longitudeMetersMax: CGFloat) -> CGPoint{
    
    let longPin = loc.coordinate.longitude
    let longUser = currentLocation.coordinate.longitude
    
    let latPin = loc.coordinate.latitude
    let latUser = currentLocation.coordinate.latitude
    
    let longDistance = abs((longPin - longUser)/degreesOnMeter)
    
    let latDistance = abs((latPin - latUser)/degreesOnMeter)
    
    let maxY = longitudeMetersMax
    let maxX = (maxY*sizeOfScreen.width)/(sizeOfScreen.height*2)
    
    let x = sizeOfScreen.width/2 + (latDistance * sizeOfScreen.width/2)/maxX
    let y = sizeOfScreen.height + (longDistance * sizeOfScreen.height)/maxY
    
    return CGPoint(x: x, y: y)
}



//
//struct TrackBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackBackView(userLocation: <#CLLocation#>, path: <#PathCustom#>)
//    }
//}
