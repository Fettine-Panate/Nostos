//
//  SwitchModeButton.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 08/06/23.
//

import SwiftUI




struct SwitchModeButton: View {
    var imageName : String
    var color : String
    
    @Binding var screen : Screens
    var body: some View {
        Button {
            withAnimation {
                screen = .circularSliderView
            }
        } label: {
            Image(systemName: imageName)
                .foregroundColor(Color(color).opacity(0.7))
        }
        .background(){
            RoundedRectangle(cornerRadius: 5.0)
                .foregroundColor(.white)
        }

    }
}

struct SwitchModeButton_Previews: PreviewProvider {
    static var previews: some View {
        SwitchModeButton(imageName: "globe", color: "midday", screen: .constant(.circularSliderView))
    }
}
