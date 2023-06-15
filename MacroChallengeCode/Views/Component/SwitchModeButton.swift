//
//  SwitchModeButton.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 08/06/23.
//

import SwiftUI




enum ImageType {
    case system(name: String)
    case custom(name: String)
}

struct SwitchModeButton: View {
    var imageType: ImageType
    var color: String
    @Binding var activity: ActivityEnum
    
    var body: some View {
        Button {
            withAnimation {
                switch activity {
                case .map:
                    activity = .sunset
                case .sunset:
                    activity = .map
                case .finished:
                    print("finished")
                }
                
            }
        } label: {
            ZStack {
                Color("white")
                switch imageType {
                case .system(let name):
                    Image(systemName: name)
                        .foregroundColor(Color(color))
                        .font(.title)
                case .custom(let name):
                    Image(name)
                        .foregroundColor(Color(color))
                        .font(.title)
                }
            }
            .cornerRadius(10)
        }
        .zIndex(activity == ActivityEnum.finished ? -1 : 0)
    }
}

struct SwitchModeButton_Previews: PreviewProvider {
    static var previews: some View {
        SwitchModeButton(imageType: .system(name: "heart.fill"), color: "midday", activity: .constant(.map))
    }
}
