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
                RoundedTriangle()
                    .frame(width: 45, height: 75)
                    .padding(.bottom, 55)
                    .opacity(0.2)
                    
                  
                 
            }
            .scaleEffect(0.7)
         
        
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
