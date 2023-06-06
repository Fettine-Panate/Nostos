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
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(
                    .black.opacity(0.15),
                    lineWidth: 130
                )
                .frame(width: 130,height: 130)
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(
                    .black.opacity(0.15),
                    lineWidth: 100
                )
                .frame(width: 100,height: 100)
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(
                    .black.opacity(0.15),
                    lineWidth: 70
                )
                .frame(width: 70,height: 70)
            Circle()
                .foregroundColor(.white)
                .frame(width: 70,height: 70)
                .shadow(radius: 1)
        }
    }
}



struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
