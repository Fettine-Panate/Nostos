//
//  RollingView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 31/05/23.
//

import SwiftUI

struct RollingView: View{
    var sunriseHour : Int
    var sunsutHour : Int
    let day : dayFase 
    init(sunriseHour: Int, sunsutHour: Int) {
        self.sunriseHour = sunriseHour
        self.sunsutHour = sunsutHour
        let d = dayFase(sunrise: sunriseHour, sunset: sunsutHour)
        self.day = d
    }
    @State private var rotationAngle: Angle = .zero
    @GestureState private var dragOffset: CGSize = .zero
    @State var index = 0.0
    
    var body: some View {
        ZStack{
            // Da lavorarci
            Color(day.hours[Int(index) % 24].color)
                .ignoresSafeArea()
                .animation(.linear, value: (Int(index) % 24))
                Rectangle()
                    .frame(width: 2,height: 20)
                    .padding(.bottom,300)
                BezelView(day: day)
                    .rotationEffect(
                    rotationAngle + Angle(radians: Double(atan2(dragOffset.height, dragOffset.width)))
                    )
                    .animation(.linear, value: ( rotationAngle + Angle(radians: Double(atan2(dragOffset.height, dragOffset.width)))))
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation
                            }
                            .onEnded { value in
                                let dragVector = CGVector(dx: value.translation.width, dy: value.translation.height)
                                let angle = Angle(radians: Double(atan2(dragVector.dy, dragVector.dx)))
                                rotationAngle += angle
                                
                                if ((rotationAngle + Angle(radians: Double(atan2(dragOffset.height, dragOffset.width)))).degrees) >= 0{
                                    index = (((rotationAngle + Angle(radians: Double(atan2(dragOffset.height, dragOffset.width)))).degrees) + 7.5)/15
                                } else {
                                    index = (360 - (((rotationAngle + Angle(radians: Double(atan2(dragOffset.height, dragOffset.width)))).degrees)) + 7.5)/15
                                    
                                }
                                index = Double((12 - (Int(index) % 24)) + 12)
                                
                          
                            }
                    )
        }
    }
}


struct RollingView_Previews: PreviewProvider {
    static var previews: some View {
        RollingView(sunriseHour: 6, sunsutHour: 18)
    }
}
