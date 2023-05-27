//
//  BoxHourView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 27/05/23.
//

import SwiftUI

struct BoxHourView: View {
    var body: some View {
        VStack{
            ZStack{
                Color.red
                VStack{
                    HStack{
                        Text("PlaceHolder")
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }.padding(.horizontal)
                    AnimationProgressiveBarView()
                        .padding(.horizontal)
                    HStack{
                        Text("PlaceHolder")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }.padding(.horizontal)
                    HStack{
                        Text("PlaceHolder2")
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }.padding(.horizontal)
                }
            }
        }
        .cornerRadius(10)
    }
}

struct BoxHourView_Previews: PreviewProvider {
    static var previews: some View {
        BoxHourView()
    }
}
