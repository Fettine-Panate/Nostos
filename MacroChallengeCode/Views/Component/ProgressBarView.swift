//
//  ProgressBarView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 27/05/23.
//

import SwiftUI

struct AnimationProgressiveBarView: View {
    @State var progress: Double = 0.0
    let timer = Timer
        .publish(every: 0.1, on: .main, in: .common)
        .autoconnect()
    
    var duration: Double = 24.0
    
    
    var body: some View {
        VStack {
            ZStack {
                ProgressBarView(duration: duration, progress: progress)
            }
            .onReceive(timer) { time in
                if progress <= duration{
                    progress = progress + 0.1
                }else{
                    progress = 0.0
                }
            }
        }
        
    }
}


struct ProgressBarView: View {
    let duration : Double
    let progress : Double
    
    
    var body: some View {
        var proportion = (progress * 360)/duration
        ZStack{
            Color.black.opacity(0.4)
            HStack{
                Rectangle()
                    .frame(width:CGFloat(proportion),height: 8)
                    .foregroundColor(
                        Color("white"))
                    .animation(.easeOut, value: proportion)
                Spacer()
            }
        }.frame(height: 8)
            .cornerRadius(10)
    }
}

/*
 struct AnimationProgressiveBarView_Previews: PreviewProvider {
 static var previews: some View {
 AnimationProgressiveBarView()
 }
 }
 */

