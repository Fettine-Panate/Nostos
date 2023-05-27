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
                Color.red
                VStack{
                    HStack{
                        Text(text)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
        .cornerRadius(10)
    }
}

//struct BoxNavigationButton_Previews: PreviewProvider {
//    static var previews: some View {
//        BoxNavigationButton()
//    }
//}
