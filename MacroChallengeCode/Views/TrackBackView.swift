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
    @Binding var currentUserLocation : CLLocation?
    @ObservedObject var previouspath : PathCustom
    @State var path : PathCustom = PathCustom(title: "\(Date().description)")
    @StateObject var compassHeading = CompassHeading()
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    
    
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    @State var index = 0
    
    var ns: Namespace.ID
    
    @Binding var magnitude : Double
    let day : DayPhase
    
    @Binding var scale : Double
    
    var body: some View{
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        GeometryReader { geometry in
            ZStack{
                ForEach(path.locations, id: \.self){ loc in
                    if isDisplayable(loc: loc, currentLocation: currentUserLocation!, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                        let position = calculatePosition(loc: loc, currentLocation: currentUserLocation!, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                        if loc == path.locations.first{
                            LastPinAnnotationView(loc: loc)
                                .position(position)
                                .animation(.linear, value: position)
                                .scaleEffect(scale)
                                .onAppear{
                                    index += 1
                                }
                        } else if loc == path.locations.last {
                            FirstPinAnnotationView(loc: loc)
                                .position(position)
                                .animation(.linear, value: position)
                                .scaleEffect(scale/3)
                        } else{
                            PinAnnotationView(loc: loc)
                                .position(position)
                                .animation(.linear, value: position)
                                .scaleEffect(scale/3)
                        }
                    }
                }.rotationEffect(Angle(degrees: -self.compassHeading.degrees))
                
                IndicatorView()
                    .foregroundColor(Color.black.opacity(day.getClosestPhase(currentTime: .now).color.accentObjectOp + 0.1))
                    .matchedGeometryEffect(id: "indicator", in: ns)
                    .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                Avatar()
                    .foregroundColor(Color("white"))
                    .matchedGeometryEffect(id: "avatar", in: ns)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            mapScreen = .mapView
                        }
                    }
            }
            .background{
                MapBackground(size: geometry.size, day: day, magnitude: $magnitude, ns: ns)
            }
            .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height * 1/2))
            .onAppear(){
                self.path = PathCustom(path: self.previouspath)
            }
            .onChange(of: currentUserLocation) { newValue in
                
                if(defaults.integer(forKey: "ON_BOARDING") > 4){
                    if (path.removeCheckpoint(currentUserLocation: currentUserLocation!)){
                        if(path.locations.isEmpty){
                            withAnimation {
                                screen = .finished
                            }
                        }
                    }
                }
                
            }
        }
        
    }
    
    //                        .overlay{
    //                            ZStack{
    //                                withAnimation{
    //                                    Path { pat in
    //                                        for (index, loc) in path.getLocations().enumerated() {
    //                                            if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
    //                                                let point = calculatePosition(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
    //                                                if index == 0 {
    //                                                    pat.move(to: point)
    //                                                } else {
    //                                                    pat.addLine(to: point)
    //                                                }
    //                                            }
    //                                        }
    //                                        pat.addLine(to: CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
    //                                    }
    //                                    .stroke(Color.white, lineWidth: 2 * scale)
    //                                    .scaleEffect(scale / 2)
    //                                }
    //                            }
    //                        }
    
}





//
//struct TrackBackView_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackBackView(userLocation: <#CLLocation#>, path: <#PathCustom#>)
//    }
//}
