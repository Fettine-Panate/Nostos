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
                
                    Color("white")
                VStack{
                    HStack{
                        Text(text)
                            .fontWeight(.bold)
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
