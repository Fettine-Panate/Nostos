//
//  ActivityContainerView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 09/06/23.
//

import SwiftUI
import CoreLocation
import SunKit




struct ActivityContainerView: View {
    @State var onBoardIndex = defaults.integer(forKey: "ON_BOARDING")
    
    @Binding var pathsJSON : [PathCustom]
    @Binding var userLocation : CLLocation?
    @StateObject var path : PathCustom = PathCustom(title: "\(Date().description)")
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    @State var sun : Sun?
    var ns: Namespace.ID
    @State var alertIsPresented = false
    
    @State var start = Date()

    @State var magnitude : Double = 40.0
    @State var scale : Double = 1.0
    @Binding var resumeLastPath : Bool
    

    
    @State var dateOfAvatarPosition = Date()
    @State var currentTime = dateFormatterHHMM.string(from: Date())
    @State var color = ""
    
    var body: some View {
        let day = DayPhase(sun: Sun(location: userLocation!, timeZone: TimeZone.current))
        
        GeometryReader{ geo in
            ZStack{
//                Color(day.hours[currentHour].color).ignoresSafeArea()
                // MARK: Changed the color background logic. Please check, with <3 Pietro
                withAnimation {
                    Color(color).ignoresSafeArea()
                }
                
                switch activity {
                case .map:
                    ShowPathView(pathsJSON: $pathsJSON, userLocation: $userLocation, path: path, mapScreen: $mapScreen,activity: $activity, screen: $screen, ns: ns, magnitude: $magnitude, day : day, geometry: geo.size, scale: $scale)
                    
                    BoxSliderView(magnitude: $magnitude, scale: $scale)
                        .frame(width: geo.size.width * 0.11, height: geo.size.width * 0.22).position(x: geo.size.width * 0.9, y: geo.size.height * 0.21)
                        .foregroundColor( Color(color))
                case .sunset:
                    CircularSliderView(pathsJSON: $pathsJSON, path: path, userLocation: $userLocation, sunset: Sun(location: LocationManager.shared.userLocation!, timeZone: TimeZone.current).sunset, start: start, screen: $screen,activity: $activity, mapScreen: $mapScreen, namespace: ns, day : day, dateOfAvatarPosition: $dateOfAvatarPosition)
                        .padding(70)
               
                }
                
                Button {
                        alertIsPresented = true
                } label: {
                    VStack{
                        Text(LocalizedStringKey(".StopActivity"))
                            .fontWeight(.semibold)
                            .padding()
                            .foregroundColor(Color(color))
                        
                    }
                    .frame(minWidth: geo.size.width * 0.4, minHeight: geo.size.width * 0.11)
                  
                    .background(){
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: geo.size.width * 0.11)
                            .foregroundColor(Color("white"))
                    }
                }
                .position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)
                .alert(isPresented: $alertIsPresented){
                    Alert(title: Text(LocalizedStringKey(".DoYouWantoToQuit?")), message: Text(".AllThePinsLeft_description"),
                          primaryButton: .destructive(Text(LocalizedStringKey(".Quit"))) {
                            withAnimation {
                                defaults.set(false, forKey: "IS_STARTED")
                                screen = .startView
                                //TODO: create a func to do this
                                mapScreen = .mapView
                                activity = .map
                                // TODO: Stop the activity
                                LiveActivityManager.shared.stopActivity()
                            }
                          },
                          secondaryButton: .cancel(Text(LocalizedStringKey(".Cancel")), action: {
                              alertIsPresented = false
                          }))
                        
                    }
                
                SwitchModeButton(imageType: (activity == .map) ? ImageType.custom(name: "sunmode") : ImageType.system(name: "target"), color: color, activity: $activity
                ).frame(width: geo.size.width * 0.11, height: geo.size.width * 0.11)
                    .position(x: geo.size.width * 0.9, y: geo.size.height * 0.1)
                
                    if ((userLocation!.horizontalAccuracy) > 17.0){
                        withAnimation(.linear(duration: 0.2)){
                        LowAccuracyView(size: CGSize(width: geo.size.width * 0.11, height: geo.size.width * 0.11))
                            .position(x: geo.size.width * 0.1, y: geo.size.height * 0.1)
                            .foregroundColor(Color("white"))
                    }
                }
                
                
                
                FocusViewOnBoarding(onBoardIndex: $onBoardIndex, size: [CGSize(width: 70, height: 60), CGSize(width: geo.size.width * 0.9, height: geo.size.width * 0.9), CGSize(width: 70, height: 70), CGSize(width: 70, height: 70), CGSize(width: geo.size.width * 0.5, height: geo.size.height * 0.2) ], text: [LocalizedStringKey(".TapToSwitchToSunsetMode"),LocalizedStringKey(".DragTheSliderToSee"), LocalizedStringKey(".TapToSwitchToGoingMode"), ".LongPressToComingBackMode", LocalizedStringKey(".TapToEndActivity") ], positionCircle: [CGPoint(x: geo.size.width * 0.9, y: geo.size.height * 0.1), CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.5),CGPoint(x: geo.size.width * 0.9, y: geo.size.height * 0.1), CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.5),  CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.9)], gesture: [
                    
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
                                    mapScreen = .mapView
                                    activity = .map
                                }
        
                            })
                    
                ])
            }
            .onAppear {
                sun = Sun(location: userLocation!, timeZone: TimeZone.current)
                print(sun?.astronomicalDawn)
                
                if resumeLastPath && !pathsJSON.isEmpty && defaults.bool(forKey: "IS_STARTED"){
                    path.copy(path: pathsJSON.last!)
                }
                
                color = day.getClosestPhase(currentTime: Date()).color.backgroundColor
            }
            .onChange(of: dateOfAvatarPosition){ hour in
                withAnimation(){
                    color = day.getClosestPhase(currentTime: hour).color.backgroundColor
                }
            }
        }
    }
}


struct ActivityContainerView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityContainerView(pathsJSON: .constant([]), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), path: PathCustom(title: "Hello"), screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.trackBack), ns: Namespace.init().wrappedValue, resumeLastPath: .constant(false))
    }
}

struct LowAccuracyView : View{
    let size : CGSize
    
    var body: some View{
        HStack{
            Image(systemName: "antenna.radiowaves.left.and.right.slash")
                .frame(width: size.width,height: size.height)
                .font(.title)
        }
    }
}
