//
//  BeamShape.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import SwiftUI

struct BeamShape: Shape {
    var rotation: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let startPoint = CGPoint(x: rect.midX, y: rect.midY)
        let endPoint = CGPoint(x: rect.midX, y: rect.minY)
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat(rotation))
        let rotatedPath = path.applying(rotationTransform)
        
        return rotatedPath
    }
}

