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
        GeometryReader{ gr in
                    VStack(spacing: 0){
                        HStack{
                            ZStack{
                                if magnitude >= 10000{
                                    Color.gray
                                } else {
                                    Color.white
                                }
                                Button(action: {
                                    if magnitude < 10000{
                                        magnitude = magnitude + 100
                                    }}, label: {
                                        Text("+")
                                    }).background(){
                                        if magnitude >= 10000{
                                            Color.gray
                                        } else{
                                            Color.white
                                        }
                                    }
                            }
                        }
                        .frame( height: gr.size.height * 48/100)
                        HStack{
                            Spacer()
                        }
                        .frame(height: gr.size.height * 2/100)
                        HStack{
                            ZStack{
                                if magnitude <= 100{
                                    Color.gray
                                } else {
                                    Color.white
                                }
                                Button(action: {
                                    if magnitude > 100{
                                        magnitude = magnitude - 100
                                    } }, label: {
                                        Text("-")
                                    }).background(){
                                        if magnitude <= 100{
                                            Color.gray
                                        } else {
                                            Color.white
                                        }
                                    }
                            }
                        }
                        .frame(height: gr.size.height * 48/100)
                    }
                    .cornerRadius(10)
        }
    }
}

struct BoxSliderView_Previews: PreviewProvider {
    static var previews: some View {
        BoxSliderView(magnitude: .constant(100.0))
    }
}
