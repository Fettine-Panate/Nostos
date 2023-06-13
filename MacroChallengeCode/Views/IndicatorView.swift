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
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .trim(from: 0.125,to: 0.625)
                    .frame(width: 35,height: 35)
                
            }.rotationEffect(Angle(degrees: 135))
                .scaleEffect(0.7)
                .padding(.bottom,25)
        }
    }
}



struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
