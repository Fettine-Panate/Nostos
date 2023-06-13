//
//  MapBackground.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import SwiftUI
import MapKit

struct MapBackground: View {
    var size : CGSize
    let day : dayFase
    
    
    var ns: Namespace.ID {
        _ns ?? namespace
    }
    @Namespace var namespace
    let _ns: Namespace.ID?
    
    
    var body: some View {
        let radius = (min(size.width, size.height) / 2.0)  * 0.9
        let sliderWidth = 10.0
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        ZStack {
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: size.height/4, height: size.height/4)
                .matchedGeometryEffect(id: "cir", in: ns)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: (2 * size.height)/4, height: (2 * size.height)/4)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: (3 * size.height)/4, height: (3 * size.height)/4)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: size.height, height: size.height)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: size.height * 5/4, height: size.height * 5/4)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: size.height * 6/4, height: size.height * 6/4)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: sliderWidth)
                .frame(width: size.height * 7/4, height: size.height * 7/4)
        }
    }
}

struct MapBackground_Previews: PreviewProvider {
    static var previews: some View {
        MapBackground(size: CGSize(width: 393.0, height: 759.0), day: dayFase(sunrise: 06, sunset: 18), _ns: Namespace.init().wrappedValue)
    }
}
