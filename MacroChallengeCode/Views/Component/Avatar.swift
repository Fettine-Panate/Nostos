//
//  Avatar.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 07/06/23.
//

import SwiftUI

struct Avatar: View {
    
    @State var screen : Screens = .startView
    
    var body: some View {
        
        Circle()
            .frame(width: 35, height: 35)
            .shadow(radius: 1)
        //                   .scaleEffect(0.5)
        //                   .foregroundColor(.white)
        //                   .onTapGesture {
        //                       screen = .mapScreenView
        //                   }
        
    }
    
    
}




struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar(screen: .startView)
    }
}
