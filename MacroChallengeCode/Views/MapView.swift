//
//  MapView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 25/05/23.
//

import SwiftUI
import CoreLocation
import Combine
import ActivityKit

let degreesOnMeter = 0.0000089
let magnitudeinm = 250.0



struct MapView: View {
    var path : PathCustom
    @StateObject var compassHeading = CompassHeading()
    @Binding var currentUserLocation : CLLocation?
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    @State var magnitude = 100.0
    @State var scale = 1.0
    
    @Binding var screen : Screens
    @Binding var mapScreen : MapSwitch
    @Binding var pathsJSON : [PathCustom]
    
    var ns: Namespace.ID {
        _ns ?? namespace
    }
    @Namespace var namespace
    let _ns: Namespace.ID?
    
    var body: some View {
   
        GeometryReader { geometry in
            ZStack {
                IndicatorView()
                    .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                ForEach(path.locations, id: \.self ){ loc in
                    if isDisplayable(loc: loc, currentLocation: currentUserLocation!, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                        let position = calculatePosition(loc: loc, currentLocation: currentUserLocation!, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                        PinAnnotationView(loc: loc)
                            .position(position)
                            .animation(.linear, value: position)
                            .scaleEffect(scale/2)
                        
                    }
                }
                Avatar()
                    .matchedGeometryEffect(id: "avatar", in: ns)
                    .foregroundColor(.white)
                    .onLongPressGesture {
                        withAnimation {
                           mapScreen = .trackBack
                        }
                    }
            }.background(){
                MapBackground(size: geometry.size)
            }
            .frame(width: geometry.size.width,height: geometry.size.height)
            .onAppear {
                path.addLocation(currentUserLocation!, checkLocation: path.checkDistance)
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
            .onChange(of: currentUserLocation) { loc in
                path.addLocation(loc!, checkLocation: path.checkDistance)
                pathsJSON.removeLast()
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(path: PathCustom(title: "hello"), currentUserLocation: .constant(CLLocation(latitude: 40.837034, longitude: 14.306127)), screen: .constant(.activity), mapScreen: .constant(.mapView), pathsJSON: .constant([]), _ns: nil)
    }
}





func calculatePosition(loc: CLLocation, currentLocation: CLLocation, sizeOfScreen: CGSize, latitudeMetersMax: CGFloat) -> CGPoint{
    
    let longPin = loc.coordinate.longitude
    let longUser = currentLocation.coordinate.longitude
    
    let latPin = loc.coordinate.latitude
    let latUser = currentLocation.coordinate.latitude
    
    let longDistance = (longPin - longUser)/degreesOnMeter
    
    let latDistance = (latPin - latUser)/degreesOnMeter
    
    let maxY = latitudeMetersMax
    let maxX = (maxY*sizeOfScreen.width)/sizeOfScreen.height
    
    let y = sizeOfScreen.height/2 - (latDistance * sizeOfScreen.height)/maxY
    let x = sizeOfScreen.width/2 + (longDistance * sizeOfScreen.width)/maxX
    
    return CGPoint(x: x, y: y)
}


func isDisplayable(loc: CLLocation, currentLocation: CLLocation, sizeOfScreen: CGSize, latitudeMetersMax: CGFloat) -> Bool{
    
    let longPin = loc.coordinate.longitude
    let longUser = currentLocation.coordinate.longitude
    
    let latPin = loc.coordinate.latitude
    let latUser = currentLocation.coordinate.latitude
    
    let longDistance = abs((longPin - longUser)/degreesOnMeter)
    
    let latDistance = abs((latPin - latUser)/degreesOnMeter)
    
    let maxY = latitudeMetersMax
    let maxX = (maxY*sizeOfScreen.width)/sizeOfScreen.height
    
    return ((latDistance < maxY) && (longDistance < maxX))
}
