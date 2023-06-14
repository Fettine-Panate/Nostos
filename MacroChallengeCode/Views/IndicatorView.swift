//
//  IndicatorView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 23/05/23.
//

import SwiftUI

struct IndicatorView: View {
    
    var body: some View {

            ZStack{

                RoundedRectangle(cornerRadius: 10)
                    .trim(from: 0.125,to: 0.625)
                    .frame(width: 35,height: 35)
                
            }.rotationEffect(Angle(degrees: 135))
                .scaleEffect(0.7)
                .padding(.bottom,20)
        }

}


struct RoundedTriangle : Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let topPoint = CGPoint(x: rect.midX, y: rect.minY)
        
        let startPoint = CGPoint(x: rect.minX, y: rect.maxY)
        let endPoint = CGPoint(x: rect.maxX, y: rect.maxY)
        
        path.move(to: endPoint)
        path.addArc(tangent1End: topPoint, tangent2End: startPoint, radius: rect.size.width * 0.2)
        path.addLine(to: startPoint)
        path.addLine(to: endPoint)
        
        return path
    }
}

struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
