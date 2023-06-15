//
//  StartView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 26/05/23.
//

import SwiftUI
import CoreLocation
import SunKit



struct StartView: View {
    @Binding var pathsJSON : [PathCustom]
    @ObservedObject var locationManager = LocationManager.shared
    @State var isStarted = false
    @State var isPresented = false
    @State var sun : Sun?
    @Binding var screen: Screens
    var ns: Namespace.ID
    
    var body: some View {
        
        GeometryReader{ geo in
            ZStack {
                Color.orange.ignoresSafeArea()
                Avatar()
                    .matchedGeometryEffect(id: "avatar", in: ns)
                    .foregroundColor(
                        Color("white"))
                Button {
                    withAnimation {
                        screen = .activity
                        // TODO: Start the activity and schedule notification
                        let location : CLLocation = LocationManager.shared.userLocation!
                        if defaults.integer(forKey: "ON_BOARDING") >= 5 {
                            //NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", sunset: Sun(location: location, timeZone: TimeZone.current).sunset , start: Date())
                            NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", timeInterval: 5)
                            LiveActivityManager.shared.addActivity()
                        }
                    }
                } label: {
                    VStack{
                        Text("Start Activity")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.orange)
                            .padding()
                    }.background(){
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color("white"))
                    }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
            }
        }
    }
    
    
    //    var body: some View {
    //        if(!isStarted){
    //            ZStack{
    //                    RollingView(sunriseHour: 6, sunsutHour: 21)
    //                        .scaleEffect(1.2)
    //                if pathsJSON.count > 0{
    //                    VStack{
    //                        Spacer()
    //                        Button(action: {
    //                            isPresented = true
    //                        }){
    //                            VStack{
    //                                Text("Your paths")
    //                                    .padding()
    //
    //                            }.background(){
    //                                Color.red.opacity(0.4)
    //                            }
    //                            .cornerRadius(20)
    //                        }
    //                    }
    //                }
    //                    VStack{
    //                        SemisphereButton {
    //                            withAnimation {
    //                                if(LocationManager.shared.userLocation == nil){
    //                                    LocationManager.shared.requestLocation()
    //                                }
    //                                isStarted = true
    //                                //hapticManager?.playFeedback()
    //                            }
    //                        }.scaleEffect(0.8)
    //                    }
    //                    .sheet(isPresented: $isPresented){
    //                        ListPathsView(paths: pathsJSON)
    //                        .presentationDetents([.medium])
    //                    }
    //            }
    //        }else if let userLocation = locationManager.userLocation {
    //            ShowPathView(pathsJSON: $pathsJSON, userLocation: userLocation)
    //        }
    //    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(pathsJSON: .constant([]), screen: .constant(.startView), ns: Namespace.init().wrappedValue)
    }
}
