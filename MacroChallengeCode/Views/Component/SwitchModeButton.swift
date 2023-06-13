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
    
    @Binding var activity : ActivityEnum
    
    var body: some View {
        Button {
            withAnimation {
                switch activity {
                case .map:
                    activity = .sunset
                case .sunset:
                    activity = .map

                }
                
            }
        } label: {
            ZStack{
                
                    Color("white")
                Image(systemName: imageName)
                    .foregroundColor(Color(color).opacity(0.7))
            }.cornerRadius(10)
        }

    }
}

struct SwitchModeButton_Previews: PreviewProvider {
    static var previews: some View {
        SwitchModeButton(imageName: "globe", color: "midday", activity: .constant(.map))
    }
}