//
//  StartView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 26/05/23.
//

import SwiftUI
import CoreLocation


struct StartView: View {
    @ObservedObject var locationManager = LocationManager.shared
    @State var isStarted = false
    var hapticManager = HapticManager()
    
    var body: some View {
        if(!isStarted){
            ZStack{
                RollingView(sunriseHour: 6, sunsutHour: 18)
                    .scaleEffect(1.2)
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
            }
        }else if let userLocation = locationManager.userLocation {
            MapScreen(userLocation: userLocation)
        }
    }
}

struct StartView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
