//
//  BoxDataView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 27/05/23.
//

import SwiftUI

struct BoxDataView: View {
    var text : String
    var body: some View {
        VStack{
            ZStack{
                Color.red
                Color.black.opacity(0.2)
                VStack{
                    HStack{
                        Text(text)
                            .fontWeight(.bold)
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

struct BoxDataView_Previews: PreviewProvider {
    static var previews: some View {
        BoxDataView(text: "ciao \nciao")
    }
}
