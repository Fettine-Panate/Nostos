//
//  ActivateGPS.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 19/06/23.
//

import SwiftUI

struct ActivateGPS: View {
    
    @Binding var screen : Screens
    @Binding var mapScreen : MapSwitch
    @Binding var activity : ActivityEnum
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Color("background").ignoresSafeArea()
                VStack{
              
                    Image(systemName: "location")
                        .resizable()
                        .foregroundColor(Color("white"))
                        .scaledToFit()
                        .frame(maxWidth: geo.size.width * 0.15)

                    Text(LocalizedStringKey(".ActivateGPS"))
                        .foregroundColor(.white)
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                    Text(LocalizedStringKey(".ActivateGPSDescription"))
                        .foregroundColor(.white)
                        .font(.title2)
                        .padding(.horizontal, 20)
                        .multilineTextAlignment(.center)
                 
                }.position(CGPoint(x: geo.size.width/2, y: geo.size.height/2))
                Button {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                    withAnimation {
                        screen = .startView
                        mapScreen = .mapView
                        activity = .map
                    }
                } label: {
                    Text(LocalizedStringKey(".OpenSettings"))
                        .foregroundColor(.blue)
                        .padding()
                        .background{
                            RoundedRectangle(cornerRadius: 10)
                            
                                .frame(height: geo.size.width * 0.11)
                                .foregroundColor(Color("white"))
                        }
                        
                }.position(x: geo.size.width * 0.5, y: geo.size.height * 0.9)

            }
        }
    }
}

struct ActivateGPS_Previews: PreviewProvider {
    static var previews: some View {
        ActivateGPS(screen: .constant(.activity), mapScreen: .constant(.mapView), activity: .constant(.map))
    }
}
