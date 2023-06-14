//
//  FocusViewOnBoarding.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 14/06/23.
//

import SwiftUI

struct FocusViewOnBoarding<T: Gesture>: View {
    
    var size : CGSize
    var text : String
    var positionCircle : CGPoint
    var gesture: T

    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Color.black.opacity(0.2).ignoresSafeArea()
                VStack{
                    Circle()
                        .gesture(gesture)
                        .frame(width: size.width, height: size.height)
                        .blendMode(.destinationOut)
                       
                        .overlay(
                            Circle()
                                .strokeBorder(Color.clear, lineWidth: 0)
                        )
                       
                    Text(text)
                        .font(.system(size: 16, design: .rounded))
                        .foregroundColor(.white)
                        .bold()
                }
                .position( CGPoint(x: 0 + positionCircle.x, y: 10 + positionCircle.y))
            }.compositingGroup()
                
            
        }
    }
}

struct FocusViewOnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        FocusViewOnBoarding(size: CGSize(width: 200, height: 200), text: "Hello baby..", positionCircle: CGPoint(x: 500, y: 500), gesture: TapGesture())
    }
}
