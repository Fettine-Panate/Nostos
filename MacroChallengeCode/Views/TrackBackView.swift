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
    @StateObject var previouspath : PathCustom
    @State var path : PathCustom = PathCustom()
    @StateObject var compassHeading = CompassHeading()
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    @State var magnitude = 100.0
    @State var scale = 1.0
    var hapticManager = HapticManager()
    
    

    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                ZStack{
                    IndicatorView()
                        .scaleEffect(0.2)
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
                                    pat.addLine(to: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                                }
                                .stroke(Color.red, lineWidth: 2 * scale)
                                .scaleEffect(scale / 2)
                            }
                        }
                    }
                }.rotationEffect(Angle(degrees: -self.compassHeading.degrees))
                    .background(){
                        MapBackground(size: geometry.size)
                    }
//                    .gesture(
//                        MagnificationGesture()
//                            .updating($magnification) { value, magnification, _ in
//                                magnification = value
//                            }
//                            .onChanged { value in
//                                currentValue = value
//                                magnitude = value * magnitudeinm
//                                scale = 1/value
//                            }
//                    )
            }
            .onChange(of: currentUserLocation) { loc in
                print("Sono entrato")
                if path.removeCheckpoint(currentUserLocation: loc){
                    hapticManager?.playFeedback()
                }
                print(path.getLocations().count)
                print(previouspath.getLocations().count)
            }
            .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height * 2/3))
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
        .onAppear(){
            self.path = PathCustom(path: self.previouspath)
        }
    }
}





//
//struct TrackBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackBackView(userLocation: <#CLLocation#>, path: <#PathCustom#>)
//    }
//}
