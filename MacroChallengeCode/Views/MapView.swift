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
import SunKit

let degreesOnMeter = 0.0000089
let magnitudeinm = 250.0

struct MapView: View {
    var path : PathCustom
    @ObservedObject var locationManager = LocationManager.shared
    @StateObject var compassHeading = CompassHeading()
    var currentUserLocation : CLLocation
    @GestureState private var magnification: CGFloat = 1.0
    @State private var currentValue: CGFloat = 0.0
    @State var magnitude = 100.0
    @State var scale = 1.0
    @State var isRunning = false
    @State var sun: Sun?
    @State var activity: Activity<SunsetWidgetAttributes>? = nil
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack{
                    BoxNavigationButton(text: "Hiking!")
                        .frame(height: 50)
                        .padding(.horizontal)
                    BoxDataView(text: "Range on screen: \(magnitude) m ")
                        .frame(height: 50)
                        .padding(.horizontal)
                    BoxSliderView(magnitude: $magnitude)
                        .frame(height: 40)
                        .padding(.horizontal)
                    Spacer()
                }
                IndicatorView()
                    .position(CGPoint(x: geometry.size.width/2, y: geometry.size.height/2))
                    .scaleEffect(0.2)
                    .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                ForEach(path.getLocations(), id: \.self ){ loc in
                    if isDisplayable(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude){
                        let position = calculatePosition2(loc: loc, currentLocation: currentUserLocation, sizeOfScreen: geometry.size, latitudeMetersMax: magnitude)
                        PinAnnotationView(loc: loc)
                            .position(position)
                            .animation(.linear, value: position)
                            .scaleEffect(scale/2)
                    }
                }
            }.background(){
                MapBackground(size: geometry.size)
            }
            .frame(width: geometry.size.width,height: geometry.size.height)
            .onAppear {
                if !isRunning {
                    sun = Sun(location: currentUserLocation, timeZone: TimeZone.current)
                    sun?.setDate(.now)
                    addActivity()
                    isRunning.toggle()
                }
            }
            //            .gesture(
            //                MagnificationGesture()
            //                    .updating($magnification) { value, magnification, _ in
            //                        magnification = value
            //                    }
            //                    .onChanged { value in
            //                        currentValue = value
            //                        magnitude = value * magnitudeinm
            //                        scale = 1/value
            //                    }
            //            )
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(path: PathCustom(), currentUserLocation: CLLocation(latitude: 40.837034, longitude: 14.306127))
    }
}

struct Constants {
    static let minLatitude = -90.0
    static let maxLatitude = 90.0
    static let minLongitude = -180.0
    static let maxLongitude = 180.0
}


func calculatePosition(for element: CLLocation, in size: CGSize) -> CGPoint {
    let latitudeRatio = (element.coordinate.latitude - Constants.minLatitude) / (Constants.maxLatitude - Constants.minLatitude)
    let longitudeRatio = (element.coordinate.longitude - Constants.minLongitude) / (Constants.maxLongitude - Constants.minLongitude)
    
    let x = longitudeRatio * size.width
    let y = latitudeRatio * size.height
    
    return CGPoint(x: x, y: y)
}

func calculatePosition2(loc: CLLocation, currentLocation: CLLocation, sizeOfScreen: CGSize, latitudeMetersMax: CGFloat) -> CGPoint{
    
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

extension MapView {
    
    func addActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("\(ActivityAuthorizationError.self)")
            return
        }
        guard Activity<SunsetWidgetAttributes>.activities.isEmpty else {
            print("Cannot run multiple istance of the same activity!")
            return
        }
        let attributes = SunsetWidgetAttributes(sunsetTime: sun?.sunset ?? .now)
        let state = SunsetWidgetAttributes.ContentState()
        let activityContent = ActivityContent(state: state, staleDate: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
        do {
            activity = try Activity<SunsetWidgetAttributes>.request(attributes: attributes, content: activityContent, pushType: nil)
        } catch(let error) {
            print("Error in creating live activity:  \(error.localizedDescription)")
        }
        print("Activitiy Added Successfully: \(String(describing: activity?.id))")
    }
    
    func stopActivity() {
        let finalStatus = SunsetWidgetAttributes.ContentState()
        let finalContent = ActivityContent(state: finalStatus, staleDate: nil)
        Task {
            for activity in Activity<SunsetWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending Live Activity: \(activity.id)")
            }
        }
    }
    
    
}
