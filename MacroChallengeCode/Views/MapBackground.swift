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
    let day : DayPhase
    @Binding var magnitude : Double
    
    var ns: Namespace.ID
    @State var textOpacity = 0.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(day.getClosestPhase(currentTime: .now).color.accentObjectOp), lineWidth: 17)
                .matchedGeometryEffect(id: "circle", in: ns)
                .frame(width: size.height/3, height: size.height/3)
            Circle()
                .stroke(Color.black.opacity(day.getClosestPhase(currentTime: .now).color.accentObjectOp), lineWidth: 17)
                .matchedGeometryEffect(id: "circle1", in: ns)
                .frame(width: (2 * size.height)/3, height: (2 * size.height)/3)
            
            Circle()
                .stroke(Color.black.opacity(day.getClosestPhase(currentTime: .now).color.accentObjectOp), lineWidth: 17)
                .matchedGeometryEffect(id: "circle2", in: ns)
                .frame(width: (3 * size.height)/3, height: (3 * size.height)/3)
            
            Circle()
                .stroke(Color.black.opacity(day.getClosestPhase(currentTime: .now).color.accentObjectOp), lineWidth: 17)
                .matchedGeometryEffect(id: "circle4", in: ns)
                .frame(width: size.height * 4/3, height: size.height * 4/3)
            
            Text("\(Int(magnitude/8)) m")
                .fontWeight(.bold)
                .offset(y: (-size.height/2  * 1/3) - 18 )
                .foregroundColor(Color.black.opacity(textOpacity))
            Text("\(Int(magnitude * 2/8)) m")
                .fontWeight(.bold)
                .offset(y: (-size.height/2  * 2/3) - 18 )
                .foregroundColor(Color.black.opacity(textOpacity))
            Text("\(Int(magnitude * 3/8)) m")
                .fontWeight(.bold)
                .offset(y: (-size.height/2  * 3/3) - 18 )
                .foregroundColor(Color.black.opacity(textOpacity))
//            Text("\(Int(magnitude * 4/8)) m")
//                .fontWeight(.bold)
//                .offset(y: (-size.height/2  * 4/4) - 12 )
//                .foregroundColor(Color.black.opacity(textOpacity))
           
        }
        .onChange(of: magnitude){ _ in
            textOpacity = day.getClosestPhase(currentTime: .now).color.accentObjectOp + 0.2
            withAnimation(.linear(duration: 3)){
                textOpacity = 0.0
            }
        }
    }
}

//struct MapBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        MapBackground(size: CGSize(width: 393.0, height: 759.0), day: dayFase(sunrise: 06, sunset: 18), magnitude: .constant(30.0), ns: Namespace.init().wrappedValue)
//    }
//}
