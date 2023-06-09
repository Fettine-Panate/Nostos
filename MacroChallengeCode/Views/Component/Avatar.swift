//
//  Avatar.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 07/06/23.
//

import SwiftUI

struct Avatar: View {
    
    var body: some View {
        Circle()
            .frame(width: 35, height: 35)
            .shadow(radius: 1)
    }
}




struct Avatar_Previews: PreviewProvider {
    static var previews: some View {
        Avatar()
    }
}
