//
//  CircularSliderView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 06/06/23.
//

import SwiftUI

struct CircularSliderView: View {
    @Binding var isPresented : Bool
    @State var progress1 = 0.0
    let sunset : Date
    @State private var start = Date()
    @State var currentTime =  Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(isPresented: Binding<Bool>, progress1: Double = 0.0, sunset: Date, start: Date) {
        self._isPresented = isPresented
        self.sunset = sunset
        self.start = start
        if sunset.timeIntervalSince(currentTime) >  0 {
            self.progress1 = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
        } else {
            self.progress1 = 1.0
        }
    }
    
    var body: some View {
        GeometryReader{ gr in
            ZStack {
                CircularSlider(isPresented: $isPresented, value: $progress1,sunset: sunset)
                    .frame(width:250, height: 250)
                    .rotationEffect(Angle(degrees: 180))
                    .position(CGPoint(x: gr.size.width/2, y: gr.size.height/2))
                    .animation(.easeInOut(duration: 1), value: isPresented)
                
                    .onAppear(){
                        progress1 = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
                    }
            }
            .onReceive(timer){ _ in
                currentTime = Date()
                progress1 = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
            }
        }
    }
}


struct CircularSlider: View {
    @Binding var isPresented : Bool
    @Binding var progress: Double
    let sunset : Date
    @State var yOffset = 0.0
    @State var op = 0.0
    @State private var start = Date()
    @State var currentTime = Date()
    @State var tapped : Bool = false
    @State var deltat = ""
    @State var timepassed = ""
    @State var slidertime = ""
    @State var limitAngle = 0.0
    @State private var rotationAngle = Angle(degrees: 0)
    private var minValue = 0.0
    private var maxValue = 1.0
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    init(isPresented: Binding<Bool>,value progress: Binding<Double>, in bounds: ClosedRange<Int> = 0...1, sunset: Date) {
        self._isPresented = isPresented
        self._progress = progress
        self.sunset = sunset
        
        self.minValue = Double(bounds.first ?? 0)
        self.maxValue = Double(bounds.last ?? 1)
        self.rotationAngle = Angle(degrees: progressFraction * 360.0)
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
                            Text(tapped ? slidertime + "\nTime to sunset :\n" + deltat :  "Time to start :\n" + timepassed )
                                .font(.system(size: radius * 0.2 , weight: .bold, design:.rounded))
                                .multilineTextAlignment(.center)
                                .rotationEffect(Angle(degrees: 180))
                                .opacity(op)
                        }
                    
                    //circle colorated
                    Circle()
                        .trim(from: 0.0 , to: progressFraction )
                        .stroke(.white,
                                style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round)
                        )
                        .opacity(tapped ? 0 : 1)
                        .rotationEffect(Angle(degrees: -72))
                    
                    Circle()
                        .trim(from: progressFraction, to: 0.90)
                        .stroke(.white,
                                style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round)
                        )
                        .opacity(tapped ? 1 : 0)
                        .rotationEffect(Angle(degrees: -72))
                    
                    //Circle to drag
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: (sliderWidth * 0.3))
                        .frame(width: 35, height: 35)
                        .offset(y: yOffset)
                        .rotationEffect(rotationAngle + Angle(degrees: 18.0))
                        .gesture(
                            DragGesture(minimumDistance: 0.0)
                                .onChanged() { value in
                                    changeAngle(location: value.location)
                                    deltat = formatSecondsToHMS(Int((sunset.timeIntervalSince(start) * (0.90 - progress))/0.90))
                                    slidertime = dateFormatter.string(from: start.addingTimeInterval((sunset.timeIntervalSince(start) * (progress))/0.90))
                                    tapped = true
                                    
                                }
                                .onEnded { _ in
                                    tapped = false
                                    print("false")
                                }
                        )
                }
                .frame(width: radius * 2.0, height: radius * 2.0, alignment: .center)
                .padding(radius * 0.1)
            }
            .onReceive(timer){ _ in
                if !isPresented{
                    print("cambia")
                    if yOffset > -radius{
                        print("dim")
                        yOffset = yOffset - 0.5
                    }
                    else{
                        yOffset = -radius
                    }
                    if op < 1{
                        print("dim")
                        op = op + 0.001
                    }
                    else{
                        op = 1
                    }
                }else{
                    yOffset = 0.0
                    op = 0.0
                }
                currentTime = Date()
                timepassed = formatSecondsToHMS( Int(currentTime.timeIntervalSince(start)))
                if tapped == false{
                    progress = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
                    limitAngle = progress * 360.0
                    self.rotationAngle = Angle(degrees: progress * 360.0)
                }
            }
        }
    }
    
    private func formatSecondsToHMS(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = (totalSeconds % 3600) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    
    
    private var progressFraction: Double {
        return ((progress - minValue) / (maxValue - minValue))
    }
    
    private func changeAngle(location: CGPoint) {
        let vector = CGVector(dx: location.x, dy: -location.y)
        let angleRadians = atan2(vector.dx, vector.dy)
        let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
        if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >= Angle(degrees: limitAngle){
            progress = ((positiveAngle / ((2.0 * .pi))) * (maxValue - minValue)) + minValue
            rotationAngle = Angle(radians: positiveAngle)
        }
    }
}


//struct CircularSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircularSliderView(sunset: .now, start: .now)
//    }
//}
