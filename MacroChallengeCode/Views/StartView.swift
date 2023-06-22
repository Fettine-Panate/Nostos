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
    @Binding var screen: Screens
    var ns: Namespace.ID
    @State var isStartedActivity = defaults.bool(forKey: "IS_STARTED")
    @Binding var resumeLastPath : Bool
    
    var body: some View {
        
        GeometryReader{ geo in
            ZStack {
                Color("background").ignoresSafeArea()
                Avatar()
                    .matchedGeometryEffect(id: "avatar", in: ns)
                    .foregroundColor(
                        Color("white"))
                Button {
                    withAnimation {
                        screen = .activity
                        // TODO: Start the activity and schedule notification
                        
                        if defaults.integer(forKey: "ON_BOARDING") >= 5 {
                            defaults.set(true, forKey: "IS_STARTED")
                            NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", sunset: Sun(location: locationManager.userLocation!, timeZone: TimeZone.current).sunset , start: Date())
                            guard #available(iOS 16, *) else {
                                print("Live Activity Not Supported!")
                                return
                            }
                            LiveActivityManager.shared.addActivity()
                            locationManager.startLocationUpdates()
                        }
                    }
                } label: {
                    VStack{
                        Text(LocalizedStringKey(".StartActivity"))
                            .fontWeight(.semibold)
                            .foregroundColor(Color("background"))
                            .padding()
                    }
                    .frame(minWidth: geo.size.width * 0.4, minHeight: geo.size.width * 0.11)
                 
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: geo.size.width * 0.11)
                            .foregroundColor(Color("white"))
                    }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
                
                .alert(isPresented: $isStartedActivity){
                    Alert(title: Text(LocalizedStringKey(".DoYouWantoToResume?")), message: Text(".AllThePinsLeft_description"),
                          primaryButton: .default(Text(LocalizedStringKey(".Resume"))) {
                        withAnimation {
                            resumeLastPath = true
                            screen = .activity
                            // TODO: Start the activity and schedule notification
                            if defaults.integer(forKey: "ON_BOARDING") >= 5 {
                                NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", sunset: Sun(location: locationManager.userLocation!, timeZone: TimeZone.current).sunset , start: Date())
                                guard #available(iOS 16, *) else {
                                    print("Live Activity Not Supported!")
                                    return
                                }
                                LiveActivityManager.shared.addActivity()
                                locationManager.startLocationUpdates()
                            }
                        }
                          },
                          secondaryButton: .destructive(Text(LocalizedStringKey(".No")).foregroundColor(.blue), action: {
                        isStartedActivity = false
                        defaults.set(false, forKey: "IS_STARTED")
                          }))
                          
                        
                    }
                .onAppear(){
                    print("Size of start : w : \(geo.size.width), h : \(geo.size.height)")
                }
            
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
        StartView(pathsJSON: .constant([]), screen: .constant(.startView), ns: Namespace.init().wrappedValue, resumeLastPath: .constant(false))
    }
}
