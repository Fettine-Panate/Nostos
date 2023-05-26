//
//  SemisphereButton.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 26/05/23.
//

import SwiftUI


struct SemisphereButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            ZStack {
                Circle()
                    .trim(from: 0.50, to: 1)
                    .fill(Color.blue)
                    .frame(width: 200 , height: 200)
                  //  .rotationEffect(.degrees(180))
                   
                Text("Start")
                    .foregroundColor(.white)
                    .font(.headline)
                    .padding(.bottom, 40)
                   
            }
            .padding(.top, 30)
        }
    }
}

struct SemisphereButton_Previews: PreviewProvider {
    static var previews: some View {
        SemisphereButton(action: {})
    }
}
