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
    
    
    @Binding var screen : Screens
    @Binding var mapScreen : MapSwitch
    @Binding var pathsJSON : [PathCustom]
    
    var ns: Namespace.ID
    
    @Binding var magnitude : Double
    let day : DayPhase
    
    let geometry : CGSize
    @Binding var scale : Double
    
    var body: some View {
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        
        
        
        ZStack {
            ForEach(path.locations, id: \.self ){ loc in
                if isDisplayable(loc: loc, currentLocation: currentUserLocation!, sizeOfScreen: geometry, latitudeMetersMax: magnitude){
                    let position = calculatePosition(loc: loc, currentLocation: currentUserLocation!, sizeOfScreen:  geometry, latitudeMetersMax: magnitude)
                    
                    PinAnnotationView(loc: loc)
                        .position(position)
                        .animation(.linear, value: position)
                        .scaleEffect(scale/3)
                        .onAppear{
                            print("Position of the pin: \(position)")
                        }
                    
                }
            }
            .rotationEffect(Angle(degrees: -self.compassHeading.degrees))
            
            IndicatorView()
                .foregroundColor(Color.black.opacity(day.getClosestPhase(currentTime: .now).color.accentObjectOp + 0.1))
                .matchedGeometryEffect(id: "indicator", in: ns)
            
            Avatar()
                .matchedGeometryEffect(id: "avatar", in: ns)
                .foregroundColor(
                    Color("white"))
                .onLongPressGesture {
                    withAnimation {
                        mapScreen = .trackBack
                    }
                }
        }.background(){
            MapBackground(size: geometry, day : day, magnitude: $magnitude, ns: ns)
        }
        
        .frame(width: geometry.width,height: geometry.height)
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

//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView(path: PathCustom(title: "hello"), currentUserLocation: .constant(CLLocation(latitude: 40.837034, longitude: 14.306127)), screen: .constant(.activity), mapScreen: .constant(.mapView), pathsJSON: .constant([]), ns: Namespace.init().wrappedValue, magnitude: .constant(30.0), day: dayFase(sunrise: 06, sunset: 20), geometry: CGSize())
//    }
//}





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


//Da provare in radianti
func calculatePosition2(loc: CLLocation, currentLocation: CLLocation, sizeOfScreen: CGSize, latitudeMetersMax: CGFloat) -> CGPoint {
    let longitudePin = loc.coordinate.longitude
    let longitudeUser = currentLocation.coordinate.longitude
    let latitudePin = loc.coordinate.latitude
    let latitudeUser = currentLocation.coordinate.latitude
    
    let deltaLongitude = (longitudePin - longitudeUser).radians
    let deltaLatitude = (latitudePin - latitudeUser).radians
    
    let halfScreenWidth = sizeOfScreen.width / 2
    let halfScreenHeight = sizeOfScreen.height / 2
    
    let latitudeScale = sizeOfScreen.height / latitudeMetersMax
    
    let horizontalDistance = deltaLongitude * EarthRadius * cos(latitudeUser.radians)
    let verticalDistance = deltaLatitude * EarthRadius
    
    let x = halfScreenWidth + (horizontalDistance * latitudeScale)
    let y = halfScreenHeight - (verticalDistance * latitudeScale)
    
    return CGPoint(x: x, y: y)
}


let EarthRadius: Double = 6_371_000

// Estensione per convertire un valore in radianti
extension Double {
    var radians: Double {
        return self * .pi / 180.0
    }
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
