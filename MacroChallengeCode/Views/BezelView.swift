//
//  BezelView.swift
//  ProvaAnimation
//
//  Created by Raffaele Martone on 30/05/23.
//

import SwiftUI

struct BezelView: View {
    @State var ind = 0
    let day : dayFase 
    
    var body: some View {
        ZStack{
            ForEach(day.hours.indices, id: \.self ){ ind in
                AngleView(hour: day.hours[ind].hour, color: day.hours[ind].color)
                    .rotationEffect(Angle(degrees: Double(ind) * 15.0))
            }.frame(width: 300,height: 300)
            
//        Circle()
//            .scaleEffect(0.4)
        }
    }
}


struct AngleView: View {
    let hour : Int
    let color : String
    var body: some View {
        ZStack{
            Circle()
                .trim(from: 0.729, to: 0.770)
                .stroke(
                    Color(color),
                    lineWidth: 130
                )
                .frame(width: 130,height: 130)
            Text("\(hour)")
                .fontWeight(.bold)
                .padding(.bottom,220)
        }
    }
}


struct BezelView_Previews: PreviewProvider {
    static var previews: some View {
        BezelView( day: dayFase(sunrise: 6, sunset: 18))
    }
}
