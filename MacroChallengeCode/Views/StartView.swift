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
    @State var isStartedActivity = defaults.bool(forKey: "IS_STARTED")
    @Binding var resumeLastPath : Bool
    
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
                        
                        if defaults.integer(forKey: "ON_BOARDING") >= 5 {
                            defaults.set(true, forKey: "IS_STARTED")
                            //NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", sunset: Sun(location: location, timeZone: TimeZone.current).sunset , start: Date())
                            NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", timeInterval: 5)
                            guard #available(iOS 16, *) else {
                                print("Live Activity Not Supported!")
                                return
                            }
                            LiveActivityManager.shared.addActivity()
                        }
                    }
                } label: {
                    VStack{
                        Text(LocalizedStringKey(".StartActivity"))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.orange)
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
                          primaryButton: .destructive(Text(LocalizedStringKey(".Resume"))) {
                        withAnimation {
                            resumeLastPath = true
                            screen = .activity
                            // TODO: Start the activity and schedule notification
                            if defaults.integer(forKey: "ON_BOARDING") >= 5 {
                                //NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", sunset: Sun(location: location, timeZone: TimeZone.current).sunset , start: Date())
                                NotificationManager.shared.createNotification(title: "Consider going back", body: "If you start now, you will arrive just before the sunset", timeInterval: 5)
                                guard #available(iOS 16, *) else {
                                    print("Live Activity Not Supported!")
                                    return
                                }
                                LiveActivityManager.shared.addActivity()
                            }
                        }
                          },
                          secondaryButton: .default(Text(LocalizedStringKey(".No")), action: {
                        isStartedActivity = false
                          }))
                        
                    }
            }
            .onAppear {
                sun = Sun(location: locationManager.userLocation!, timeZone: TimeZone.current)
                print("Astronomical Dawn: \(dateFormatterHHMM.string(from: sun!.astronomicalDawn))")
                print("Nautical Dawn: \(dateFormatterHHMM.string(from: sun!.nauticalDawn))")
                print("Civil Dawn: \(dateFormatterHHMM.string(from: sun!.civilDawn))")
                print("Morning Golden Hour Start: \(dateFormatterHHMM.string(from: sun!.morningGoldenHourStart))")
                print("Sunrise: \(dateFormatterHHMM.string(from: sun!.sunrise))")
                print("Morning Golden Hour End: \(dateFormatterHHMM.string(from: sun!.morningGoldenHourEnd))")
                print("Solar Noon: \(dateFormatterHHMM.string(from: sun!.solarNoon))")
                print("Evening Golden Hour Start: \(dateFormatterHHMM.string(from: sun!.eveningGoldenHourStart))")
                print("Sunset: \(dateFormatterHHMM.string(from: sun!.sunset))")
                print("Evening Golden Hour End: \(dateFormatterHHMM.string(from: sun!.eveningGoldenHourEnd))")
                print("Civil Dusk: \(dateFormatterHHMM.string(from: sun!.civilDusk))")
                print("Nautical Dusk: \(dateFormatterHHMM.string(from: sun!.nauticalDusk))")
                print("Astronomical Dusk: \(dateFormatterHHMM.string(from: sun!.astronomicalDusk))")
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
