//
//  ArrivedBackView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 14/06/23.
//

import SwiftUI
import SunKit

struct ArrivedBackView: View {
    
    @Binding var screen : Screens
    @Binding var activity: ActivityEnum
    @Binding var mapScreen : MapSwitch
    var ns: Namespace.ID
    var day: dayFase
    
    var body: some View {
    
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        
        GeometryReader{ geo in
            ZStack{
                VStack{
                    Image(systemName: "flag.checkered.2.crossed")
                        .resizable()
                        .frame(width: geo.size.width * 0.23, height: geo.size.width * 0.15)
                        .foregroundColor(Color("white"))
                        
                    Text("Congratulation")
                        .bold()
                        .foregroundColor(Color("white"))
                        .font(.system(size: 40))
                        .padding()
                    Text("You arrived at your starting point")
                        .foregroundColor(Color("white"))
                        .font(.system(size: 25))
                    Button {
                        screen = .startView
                        mapScreen = .mapView
                        activity = .map
                    } label: {
                        VStack{
                            Text("OK")
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

                }
                .position(x: geo.size.width/2, y: geo.size.height * 0.4)
               
            }
        }
       
    }
}

struct ArrivedBackView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivedBackView(screen: .constant(.activity), activity: .constant(.map), mapScreen: .constant(.mapView), ns: Namespace.init().wrappedValue, day: dayFase(sunrise: 06, sunset: 19))
    }
}
