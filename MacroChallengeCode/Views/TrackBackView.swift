//
//  TrackBackView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 26/05/23.
//

import SwiftUI
import CoreLocation
import Foundation
import SunKit


struct TrackBackView: View {
    var currentUserLocation : CLLocation
    @StateObject var previouspath : PathCustom
    @State var path : PathCustom = PathCustom(title: "\(Date().description)")
    @StateObject var compassHeading = CompassHeading()
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    @State var magnitude = 100.0
    @State var scale = 1.0
    //var hapticManager = HapticManager()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    @State var index = 0
    
    

    
    var body: some View {
        let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: currentUserLocation, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: currentUserLocation, timeZone: TimeZone.current).sunset)) ?? 21)
        
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        GeometryReader { geometry in
            ZStack{
                Color(day.hours[currentHour].color).opacity(0.7).ignoresSafeArea()
                ZStack{
                ZStack{
                    IndicatorView()
                        .scaleEffect(0.5)
                        .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                }
                ZStack {
                    ForEach(path.getLocations(), id: \.self ){ loc in
                        if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                            let position = calculatePosition(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                            if loc == path.locations[0]{
                                LastPinAnnotationView(loc: loc)
                                    .position(position)
                                    .animation(.linear, value: position)
                                    .scaleEffect(scale/2)
                                    .onAppear(){
                                        index += 1
                                    }
                            } else if loc == path.locations.last{
                                FirstPinAnnotationView(loc: loc)
                                    .position(position)
                                    .animation(.linear, value: position)
                                    .scaleEffect(scale/2)
                            } else{
                                PinAnnotationView(loc: loc)
                                    .position(position)
                                    .animation(.linear, value: position)
                                    .scaleEffect(scale/2)
                            }
                        }
                    }
                    .overlay{
                        ZStack{
                            withAnimation{
                                Path { pat in
                                    for (index, loc) in path.getLocations().enumerated() {
                                        if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                                            let point = calculatePosition(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                                            if index == 0 {
                                                pat.move(to: point)
                                            } else {
                                                pat.addLine(to: point)
                                            }
                                        }
                                    }
                                    pat.addLine(to: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                                }
                                .stroke(Color.white, lineWidth: 2 * scale)
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
                if path.removeCheckpoint(currentUserLocation: loc){
                    // a volte fa crashare l'app
                   // hapticManager?.playFeedback()
                }
            }
            .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height * 2/3))
            ZStack{
                VStack{
                    BoxSliderView(magnitude: $magnitude)
                        .frame(height: 40)
                        .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .accentColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .padding(.horizontal)
                        .rotationEffect(.degrees(-90))
                        .position(CGPoint(x: geometry.size.width * 9/10, y: geometry.size.height * 1/3))
                    Spacer()
                    BoxNavigationButton(text: "Coming back! ")
                        .frame(height: 40)
                        .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .accentColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .padding(.horizontal)
                    BoxDataView(text: "Range on screen: \(magnitude) m ")
                        .frame(height: 40)
                        .foregroundColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .accentColor(Color(day.hours[currentHour].color).opacity(0.7))
                        .padding(.horizontal)
                }
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
