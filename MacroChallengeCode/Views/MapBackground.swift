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
    @Binding var magnitude : Double
    
    var ns: Namespace.ID
    @State var textOpacity = 0.0
    
    var body: some View {
        let currentHour =  Int(dateFormatter.string(from: Date())) ?? 0
        ZStack {
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: 10)
                .matchedGeometryEffect(id: "circle", in: ns)
                .frame(width: size.height/4, height: size.height/4)
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: 10)
                .matchedGeometryEffect(id: "circle1", in: ns)
                .frame(width: (2 * size.height)/4, height: (2 * size.height)/4)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: 10)
                .matchedGeometryEffect(id: "circle2", in: ns)
                .frame(width: (3 * size.height)/4, height: (3 * size.height)/4)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: 10)
                .matchedGeometryEffect(id: "circle3", in: ns)
                .frame(width: size.height, height: size.height)
            
            Circle()
                .stroke(Color.black.opacity(day.hours[currentHour].accentObjectOp), lineWidth: 10)
                .matchedGeometryEffect(id: "circle4", in: ns)
                .frame(width: size.height * 5/4, height: size.height * 5/4)
            
            Text("\(Int(magnitude/8)) m")
                .fontWeight(.bold)
                .offset(y: (-size.height/2  * 1/4) - 12 )
                .foregroundColor(Color.black.opacity(textOpacity))
            Text("\(Int(magnitude * 2/8)) m")
                .fontWeight(.bold)
                .offset(y: (-size.height/2  * 2/4) - 12 )
                .foregroundColor(Color.black.opacity(textOpacity))
            Text("\(Int(magnitude * 3/8)) m")
                .fontWeight(.bold)
                .offset(y: (-size.height/2  * 3/4) - 12 )
                .foregroundColor(Color.black.opacity(textOpacity))
//            Text("\(Int(magnitude * 4/8)) m")
//                .fontWeight(.bold)
//                .offset(y: (-size.height/2  * 4/4) - 12 )
//                .foregroundColor(Color.black.opacity(textOpacity))
           
        }
        .onChange(of: magnitude){ _ in
            textOpacity = day.hours[currentHour].accentObjectOp + 0.2
            withAnimation(.linear(duration: 3)){
                textOpacity = 0.0
            }
        }
    }
}

struct MapBackground_Previews: PreviewProvider {
    static var previews: some View {
        MapBackground(size: CGSize(width: 393.0, height: 759.0), day: dayFase(sunrise: 06, sunset: 18), magnitude: .constant(100.0), ns: Namespace.init().wrappedValue)
    }
}
