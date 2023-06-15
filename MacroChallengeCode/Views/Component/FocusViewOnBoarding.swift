//
//  FocusViewOnBoarding.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 14/06/23.
//

import SwiftUI

struct FocusViewOnBoarding<T: Gesture>: View {
    @Binding var onBoardIndex : Int
    var size : [CGSize]
    var text : [LocalizedStringKey]
    var positionCircle : [CGPoint]
    var gesture: [T]
  
    
    
    var body: some View {
        GeometryReader{ geo in
            if(onBoardIndex <= 4){
                ZStack{
                    Color.black.opacity(0.6).ignoresSafeArea()
                  
                        Circle()
                            .gesture(gesture[onBoardIndex])
                            .frame(width: size[onBoardIndex].width, height: size[onBoardIndex].height)
                            .blendMode(.destinationOut)
                           
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.clear, lineWidth: 0)
                            )
                            .position(positionCircle[onBoardIndex])
                        Text(text[onBoardIndex])
                            .font(.system(size: 16, design: .rounded))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .bold()
                            .position(CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.76))
                    
                 
                }.compositingGroup()
            }
        }
        .opacity(onBoardIndex > 4 ? 0: 1)
    }
}

struct FocusViewOnBoarding_Previews: PreviewProvider {
    static var previews: some View {
        FocusViewOnBoarding(onBoardIndex: .constant(0), size: [CGSize(width: 200, height: 200)], text: ["Hello baby.."], positionCircle: [CGPoint(x: 500, y: 500)], gesture: [TapGesture()])
    }
}
