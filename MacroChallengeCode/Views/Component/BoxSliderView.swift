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
                        Slider(value: $magnitude, in: 200...10000, step: 1)
                            .accentColor(.red.opacity(0.3))
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
