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
                    .red.opacity(0.4),
                    lineWidth: 130
                )
                .frame(width: 130,height: 130)
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(
                    .red.opacity(0.4),
                    lineWidth: 100
                )
                .frame(width: 100,height: 100)
            Circle()
                .trim(from: 0.65, to: 0.85)
                .stroke(
                    .red.opacity(0.4),
                    lineWidth: 70
                )
                .frame(width: 70,height: 70)
            Circle()
                .foregroundColor(.red)
                .frame(width: 70,height: 70)
        }
    }
}



struct IndicatorView_Previews: PreviewProvider {
    static var previews: some View {
        IndicatorView()
    }
}
