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
    @StateObject var compassHeading = CompassHeading()
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    @State var magnitude = 100.0
    @State var scale = 1.0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ZStack{
                    IndicatorView()
                        .scaleEffect(0.6)
                        .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                }
                ZStack {
                    ForEach(path.getLocations(), id: \.self ){ loc in
                        if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                            let position = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                            PinAnnotationView(loc: loc)
                                .position(position)
                                .animation(.linear, value: position)
                                .scaleEffect(scale/2)
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
                }.frame(width: geometry.size.width,height: geometry.size.height)
                    .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                    .background(){
                        MapBackground(size: geometry.size)
                    }
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
            }.position(CGPoint(x: geometry.size.width/2, y: geometry.size.height))
                ZStack{
                    VStack{
                        BoxNavigationButton(text: "Coming back! ")
                            .frame(height: 50)
                            .padding(.horizontal)
                        BoxDataView(text: "Range on screen: \(magnitude) m ")
                            .frame(height: 50)
                            .padding(.horizontal)
                        BoxSliderView(magnitude: $magnitude)
                            .frame(height: 40)
                            .padding(.horizontal)
                            .rotationEffect(.degrees(-90))
                            .position(CGPoint(x: geometry.size.width * 9/10, y: geometry.size.height * 1/3))
                        Spacer()
                    }
                }
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
