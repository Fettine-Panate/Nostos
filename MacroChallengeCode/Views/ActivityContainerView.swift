//
//  ActivityContainerView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 09/06/23.
//

import SwiftUI
import CoreLocation
import SunKit


let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH"
    return formatter
}()

struct ActivityContainerView: View {
    @State var onBoardIndex = defaults.integer(forKey: "ON_BOARDING")
    
    @Binding var pathsJSON : [PathCustom]
    @Binding var userLocation : CLLocation?
    @StateObject var path : PathCustom = PathCustom(title: "\(Date().description)")
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    var ns: Namespace.ID
    @State var alertIsPresented = false
    
    @State var start = Date()

    @State var magnitude : Double = 40.0

    
    var body: some View {
        let day : dayFase = dayFase(sunrise: Int(dateFormatter.string(from: Sun(location: userLocation!, timeZone: TimeZone.current).sunrise)) ?? 6, sunset: Int(dateFormatter.string(from: Sun(location: userLocation!, timeZone: TimeZone.current).sunset)) ?? 21)
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        GeometryReader{ geo in
            ZStack{
                Color(day.hours[currentHour].color).ignoresSafeArea()
                
                switch activity {
                case .map:
                    ShowPathView(pathsJSON: $pathsJSON, userLocation: $userLocation, path: path, mapScreen: $mapScreen,activity: $activity, screen: $screen, ns: ns, magnitude: $magnitude, day : day)
                    
                    BoxSliderView(magnitude: $magnitude)
                        .frame(width: geo.size.width * 0.11, height: geo.size.width * 0.22).position(x: geo.size.width * 0.9, y: geo.size.height * 0.21)
                        .foregroundColor( Color(day.hours[currentHour].color))
                case .sunset:
                    CircularSliderView(pathsJSON: $pathsJSON, path: path, userLocation: $userLocation, sunset: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunset, start: start, screen: $screen,activity: $activity, mapScreen: $mapScreen, namespace: ns, day : day)
                        .padding(70)
               
                }
                
                Button {
                        alertIsPresented = true
                } label: {
                    VStack{
                        Text("Stop Activity")
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(Color(day.hours[currentHour].color))
                        
                    }
                    .frame(height: geo.size.width * 0.11)
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: geo.size.width * 0.11)
                            .foregroundColor(Color("white"))
                    }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
                .alert(isPresented: $alertIsPresented){
                    Alert(title: Text("**Do You Really Want To Quit?**"), message: Text("All the pins left until now will be permanently deleted"),
                          primaryButton: .destructive(Text("Quit")) {
                            withAnimation {
                                screen = .startView
                                //TODO: create a func to do this
                                mapScreen = .mapView
                                activity = .map
                                // TODO: Stop the activity
                                LiveActivityManager.shared.stopActivity()
                            }
                          },
                          secondaryButton: .default(Text("Cancel"), action: {
                              alertIsPresented = false
                          }))
                        
                    }
                
                SwitchModeButton(imageType: (activity == .map) ? ImageType.custom(name: "sunmode") : ImageType.system(name: "target"), color: day.hours[currentHour].color, activity: $activity
                ).frame(width: geo.size.width * 0.11, height: geo.size.width * 0.11)
                    .position(x: geo.size.width * 0.9, y: geo.size.height * 0.1)
                
                
                
                FocusViewOnBoarding(onBoardIndex: $onBoardIndex, size: [CGSize(width: 70, height: 60), CGSize(width: geo.size.width * 0.9, height: geo.size.width * 0.9), CGSize(width: 70, height: 70), CGSize(width: 70, height: 70), CGSize(width: geo.size.width * 0.5, height: geo.size.height * 0.2) ], text: ["Tap to switch to Sunset Mode", "You can drag the slider to see how much time left to sunset", "Tap to switch to \"Going\" Mode", "Long Press to switch to \"Coming back\" Mode", "Tap to end the activity!" ], positionCircle: [CGPoint(x: geo.size.width * 0.9, y: geo.size.height * 0.1), CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.5),CGPoint(x: geo.size.width * 0.9, y: geo.size.height * 0.1), CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.5),  CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.9)], gesture: [
                    
                        //SUNSET MODE
                        TapGesture().onEnded({ bool in
                           withAnimation {
                               onBoardIndex += 1
                               defaults.set(1, forKey: "ON_BOARDING")
                               activity = .sunset
                           }

                       }),
                        //SHOW THE CIRCULARSLIDER
                        TapGesture().onEnded({ bool in
                            withAnimation {
                                onBoardIndex += 1
                                defaults.set(2, forKey: "ON_BOARDING")
                                activity = .sunset
                            }

                        }),
                        //GO BACK TO MAP
                        TapGesture().onEnded({ bool in
                            withAnimation {
                                onBoardIndex += 1
                                defaults.set(3, forKey: "ON_BOARDING")
                                activity = .map
                            }
    
                        }),
                        TapGesture().onEnded({ bool in
                            withAnimation {
                                onBoardIndex += 1
                                defaults.set(4, forKey: "ON_BOARDING")
                                mapScreen = .trackBack
                            }
                        }),
                        TapGesture().onEnded({ bool in
                                withAnimation {
                                    onBoardIndex += 1
                                    defaults.set(5, forKey: "ON_BOARDING")
                                    screen = .startView
                                }
        
                            })
                    
                ])
            }
            .onAppear {
                UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = .systemBlue
            }
        }
    }
}


struct ActivityContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityContainerView(pathsJSON: .constant([]), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), path: PathCustom(title: "Hello"), screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.trackBack), ns: Namespace.init().wrappedValue)
    }
}
