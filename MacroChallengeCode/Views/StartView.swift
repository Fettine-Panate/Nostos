//
//  StartView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 26/05/23.
//

import SwiftUI
import CoreLocation


struct StartView: View {
    @Binding var pathsJSON : [PathCustom]
    @ObservedObject var locationManager = LocationManager.shared
    @State var isStarted = false
    @State var isPresented = false
    var hapticManager = HapticManager()
    
    var body: some View {
        if(!isStarted){
            ZStack{
                    RollingView(sunriseHour: 6, sunsutHour: 18)
                        .scaleEffect(1.2)
                if pathsJSON.count > 0{
                    VStack{
                        Spacer()
                        Button(action: {
                            isPresented = true
                        }){
                            VStack{
                                Text("Your paths")
                                    .padding()
                                
                            }.background(){
                                Color.red.opacity(0.4)
                            }
                            .cornerRadius(20)
                        }
                    }
                }
                    VStack{
                        SemisphereButton {
                            withAnimation {
                                if(LocationManager.shared.userLocation == nil){
                                    LocationManager.shared.requestLocation()
                                }
                                isStarted = true
                                hapticManager?.playFeedback()
                            }
                        }.scaleEffect(0.8)
                    }
                    .sheet(isPresented: $isPresented){
                        ListPathsView(paths: pathsJSON)
                        .presentationDetents([.medium])
                    }
            }
        }else if let userLocation = locationManager.userLocation {
            MapScreen(userLocation: userLocation, pathsJSON: $pathsJSON)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView(pathsJSON: .constant([]))
    }
}
