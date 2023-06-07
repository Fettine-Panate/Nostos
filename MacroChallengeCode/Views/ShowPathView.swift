//
//  ShowPathView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 06/06/23.
//

import SwiftUI
import CoreLocation
import CoreMotion
import SunKit

struct ShowPathView: View {
    @Binding var pathsJSON : [PathCustom]
    @ObservedObject var locationManager = LocationManager.shared
    @State var isStarted = false
    @State var isPresented = false
    var userLocation : CLLocation
    @StateObject var path = PathCustom(title: "\(Date().description)")
    @State private var gyroRotation = 0.0
    private let motionManager = CMMotionManager()
    //var hapticManager = HapticManager()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()
    
    
    var body: some View {
        let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: userLocation, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: userLocation, timeZone: TimeZone.current).sunset)) ?? 21)
        
        GeometryReader{ geo in
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
            ZStack{
                Color(day.hours[currentHour].color).opacity(0.7).ignoresSafeArea()
                MapScreen(userLocation: userLocation, pathsJSON: $pathsJSON).opacity(isStarted ? 0 : 1)
                    .animation(.easeInOut(duration: 0.5), value: isPresented)
                CircularSliderView(sunset: Sun(location: userLocation, timeZone: TimeZone.current).sunset, start: .now).opacity(isStarted ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: isPresented)
            Button(action: {
                isStarted.toggle()
            }){
                VStack{
                    Image(systemName: "globe")
                        .padding(5)
                        .foregroundColor(
                            Color(day.hours[currentHour].color).opacity(0.7))
                }
                .background(){
                    RoundedRectangle(cornerRadius: 5.0)
                        .foregroundColor(.white)
                }
                .scaleEffect(1.5)
            }.position(CGPoint(x: geo.size.width * 0.9, y: geo.size.height * 0.1))
        }
        }
    }
}

//struct ShowPathView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShowPathView()
//    }
//}
