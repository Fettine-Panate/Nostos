//
//  RollingView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 31/05/23.
//

import SwiftUI

struct RollingView: View{
    @State private var rotationAngle: Angle = .zero
    @GestureState private var dragOffset: CGSize = .zero
    
    var body: some View {
        VStack{
            BezelView()
                .rotationEffect(rotationAngle + Angle(radians: Double(atan2(dragOffset.height, dragOffset.width))))
                .gesture(
                    DragGesture()
                        .updating($dragOffset) { value, state, _ in
                            state = value.translation
                        }
                        .onEnded { value in
                            let dragVector = CGVector(dx: value.translation.width, dy: value.translation.height)
                            let angle = Angle(radians: Double(atan2(dragVector.dy, dragVector.dx)))
                            rotationAngle += angle
                        }
                )
        }
    }
}


struct RollingView_Previews: PreviewProvider {
    static var previews: some View {
        RollingView()
    }
}
