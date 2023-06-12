//
//  BoxNavigationButton.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 27/05/23.
//

import SwiftUI

struct BoxNavigationButton: View {
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
                    }
                }
            }
        }
        .shadow(radius: 1)
        .cornerRadius(10)
    }
}

//struct BoxNavigationButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BoxNavigationButton()
//    }
//}
