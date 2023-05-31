//
//  BoxSliderView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 27/05/23.
//

import SwiftUI
import Combine

struct BoxSliderView: View {
    @Binding var magnitude : Double
    var body: some View {
        VStack{
            ZStack{
                Color.red
                VStack{
                    HStack{
                        Slider(value: $magnitude, in: 100...10000, step: 1)
                            .accentColor(.white)
                            .padding(.horizontal)
                    }
                }
            }
        }
        .cornerRadius(10)
    }
}
//
//struct BoxSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        BoxSliderView()
//    }
//}