//
//  CircularSliderView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 06/06/23.
//

import SwiftUI

struct CircularSliderView: View {
    @State var progress1 = 0.0
    
    var body: some View {
        ZStack {
            VStack {
                CircularSlider(value: $progress1)
                    .frame(width:250, height: 250)
                    .rotationEffect(Angle(degrees: 180))
                
            }
            .padding()
        }
    }
}


struct CircularSlider: View {
    @Binding var progress: Double

    @State private var rotationAngle = Angle(degrees: 0)
    private var minValue = 0.0
    private var maxValue = 1.0
    
    init(value progress: Binding<Double>, in bounds: ClosedRange<Int> = 0...1) {
        self._progress = progress
        
        self.minValue = Double(bounds.first ?? 0)
        self.maxValue = Double(bounds.last ?? 1)
        self.rotationAngle = Angle(degrees: progressFraction * 360.0)
    }
    
    private var progressFraction: Double {
        return ((progress - minValue) / (maxValue - minValue))
    }
    
    private func changeAngle(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: -location.y)
        let angleRadians = atan2(vector.dx, vector.dy)
        let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
        if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >= Angle(degrees: 0){
            progress = ((positiveAngle / ((2.0 * .pi))) * (maxValue - minValue)) + minValue
            rotationAngle = Angle(radians: positiveAngle)
        }
    }
    
    var body: some View {
        GeometryReader { gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0) * 0.9
            let sliderWidth = radius * 0.1
            
            VStack(spacing:0) {
                ZStack {
                    Circle()
                        .trim(from: 0, to: 0.9)
                        .stroke(Color.black.opacity(0.2),
                                style: StrokeStyle(lineWidth: sliderWidth))
                        .rotationEffect(Angle(degrees: -72))
                        .overlay() {
                            Text("\((progress/0.90), specifier: "%.2f")")
                                .font(.system(size: radius * 0.6, weight: .bold, design:.rounded))
                                .rotationEffect(Angle(degrees: 180))
                        }
                    Circle()
                        .trim(from: 0.0, to: progressFraction)
                        .stroke(.white,
                                style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round)
                        )
                        .rotationEffect(Angle(degrees: -72))
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: (sliderWidth * 0.3))
                        .frame(width: sliderWidth * 2, height: sliderWidth * 2)
                        .offset(y: -radius)
                        .rotationEffect(rotationAngle + Angle(degrees: 18.0))
                        .gesture(
                            DragGesture(minimumDistance: 0.0)
                                .onChanged() { value in
                                    changeAngle(location: value.location)
                                }
                        )
                }
                .frame(width: radius * 2.0, height: radius * 2.0, alignment: .center)
                .padding(radius * 0.1)
            }
            
            .onAppear {
                self.rotationAngle = Angle(degrees: progressFraction * 360.0)
            }
        }
    }
}


struct CircularSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CircularSliderView()
    }
}
