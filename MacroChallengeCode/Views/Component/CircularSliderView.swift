//
//  CircularSliderView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 06/06/23.
//

import SwiftUI
import CoreLocation

struct CircularSliderView: View {
    @Binding var pathsJSON : [PathCustom]
    @ObservedObject var path : PathCustom
    @Binding var userLocation : CLLocation?
    @State var progress1 = 0.0
    let sunset : Date
    @State private var start = Date()
    @State var tapped = false
    @State var currentTime =  Date()
    @State var currentPosition : CGPoint?
    // let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @Binding var screen : Screens
    @Binding var activity : ActivityEnum
    @Binding var mapScreen : MapSwitch
    
    var ns: Namespace.ID {
        _ns ?? namespace
    }
    @Namespace var namespace
    let _ns: Namespace.ID?
    init(pathsJSON: Binding<[PathCustom]>, path: PathCustom, userLocation : Binding<CLLocation?>, progress1: Double = 0.0, sunset: Date, start: Date, screen : Binding<Screens>,activity: Binding<ActivityEnum>,  mapScreen: Binding<MapSwitch>, namespace: Namespace.ID? = nil) {
        self.sunset = sunset
        self._screen = screen
        self._ns = namespace
        self._mapScreen = mapScreen
        self._activity = activity
        self.path = path
        self._userLocation = userLocation
        self._pathsJSON = pathsJSON
//        self.start = start
//        if sunset.timeIntervalSince(currentTime) >  0 {
//            self.progress1 = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
//        } else {
//            self.progress1 = 1.0
//        }
    }
    
    @State var progress : Double = 0.0
    @State var rotationAngle : Double = 0.0
    @State var remaingTimeToSunset : Int = 0 //seconds
    @State var dateOfAvatarPosition : Date = Date()
    
    
    var body: some View {
      
        GeometryReader{ gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0)  * 0.9
            let sliderWidth = 0.1 * radius
            ZStack {
                //Cerchio interno
                Circle()
                    .trim(from: 0, to: 0.9)
                    .stroke(Color.black.opacity(0.2),
                    style: StrokeStyle(lineWidth: sliderWidth))
                    .rotationEffect(Angle(degrees: 108))
                    .frame(width: radius * 2, height: radius * 2)
                    .position(x: gr.size.width * 0.5, y: gr.size.height * 0.5)
                //Cerchio progress
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.blue,
                    style: StrokeStyle(lineWidth: sliderWidth))
                    .rotationEffect(Angle(degrees: 108))
                    .frame(width: radius * 2, height: radius * 2)
                    .overlay {
                        Text("PlaceHolder")
                    }
                    .position(x: gr.size.width * 0.5, y: gr.size.height * 0.5)
                Avatar()
                    .matchedGeometryEffect(id: "avatar", in: ns)
                    .offset(y: radius)
                    .rotationEffect(Angle(degrees: 18.0 + rotationAngle))
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged(){ value in
                                progress = changeProgress(value: value.location, progress: progress)
                                print(progress)
                                rotationAngle = progress * 360
                                remaingTimeToSunset = Int((sunset.timeIntervalSince(start) * progress) / 0.9)
                                dateOfAvatarPosition = start.addingTimeInterval(Double(remaingTimeToSunset))
                                
                            }
                    )
            }
            .onChange(of: userLocation) { newValue in
                path.addLocation(userLocation!, checkLocation: path.checkDistance)
                pathsJSON.removeLast()
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
        }
    }
}

func changeProgress(value: CGPoint, progress : Double) -> Double {
    let vector = CGVector(dx: -value.x, dy: value.y)
    let angleRadians = atan2(vector.dx, vector.dy)
    let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
    var ret : Double = progress
    if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >= Angle(degrees: 0){
        ret = ((positiveAngle / ((2.0 * .pi))))
    }
    print("returning : \(ret)")
    
    return ret
}
func changeAngle(value: CGPoint) -> Angle {
    let vector = CGVector(dx: value.x, dy: -value.y)
    let angleRadians = atan2(vector.dx, vector.dy)
    let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
    var ret : Angle = Angle(degrees: 0.0)
    if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >= Angle(degrees: 0){
        ret = Angle(radians: positiveAngle)
    }
    return ret
}






//                CircularSlider(value: Binding(get: {0}, set: { _, _ in }),sunset: sunset,tapped: $tapped, namespace: ns)
//                        .frame(width:250, height: 250)
//                        .rotationEffect(Angle(degrees: 180))
//                .padding()
//                .onAppear(){
//                    progress1 = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
//                }
//            }
            
            
              
       
//            .onReceive(timer){ _ in
//                currentTime = Date()
//                progress1 = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
//            }



//struct CircularSlider: View {
//    @Binding var progress: Double
//    let sunset : Date
//    @State private var start = Date()
//    @State var currentTime = Date()
//    @Binding var tapped : Bool
//    @State var deltat = ""
//    @State var timepassed = ""
//    @State var slidertime = ""
//
//    @State private var rotationAngle = Angle(degrees: 0)
//    private var minValue = 0.0
//    private var maxValue = 1.0
//
//    let dateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        return formatter
//    }()
//    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
//
//    var ns: Namespace.ID {
//        _ns ?? namespace
//    }
//    @Namespace var namespace
//    let _ns: Namespace.ID?
//
//    init(value progress: Binding<Double>, in bounds: ClosedRange<Int> = 0...1, sunset: Date, tapped: Binding<Bool>, namespace : Namespace.ID) {
//        self._progress = progress
//        self.sunset = sunset
//        self._tapped = tapped
//        self._ns = namespace
//        self.minValue = Double(bounds.first ?? 0)
//        self.maxValue = Double(bounds.last ?? 1)
//        self.rotationAngle = Angle(degrees: progressFraction * 360.0)
//    }
//
//    private var progressFraction: Double {
//        return ((progress - minValue) / (maxValue - minValue))
//    }
//
//    private func changeAngle(location: CGPoint) {
//        let vector = CGVector(dx: location.x, dy: -location.y)
//        let angleRadians = atan2(vector.dx, vector.dy)
//        let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
//        if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >= Angle(degrees: 0){
//            progress = ((positiveAngle / ((2.0 * .pi))) * (maxValue - minValue)) + minValue
//            rotationAngle = Angle(radians: positiveAngle)
//        }
//    }
//
//    var body: some View {
//        GeometryReader { gr in
//            let radius = (min(gr.size.width, gr.size.height) / 2.0) * 0.9
//            let sliderWidth = radius * 0.1
//
//            VStack(spacing:0) {
//                ZStack {
//                    Circle()
//                        .trim(from: 0, to: 0.9)
//                        .stroke(Color.black.opacity(0.2),
//                                style: StrokeStyle(lineWidth: sliderWidth))
//                        .rotationEffect(Angle(degrees: -72))
//                        .overlay() {
//                            Text(tapped ? slidertime + "\nTime to sunset :\n" + deltat :  "Time to start :\n" + timepassed )
//                                .font(.system(size: radius * 0.2 , weight: .bold, design:.rounded))
//                                .multilineTextAlignment(.center)
//                                .rotationEffect(Angle(degrees: 180))
//                        }
//                    Circle()
//                        .trim(from: 0.0, to: progressFraction)
//                        .stroke(.white,
//                                style: StrokeStyle(lineWidth: sliderWidth, lineCap: .round)
//                        )
//                        .rotationEffect(Angle(degrees: -72))
//                    Circle()
//                        //.matchedGeometryEffect(id: "avatar", in: ns)
//                        .fill(Color.white)
//                        .shadow(radius: (sliderWidth * 0.3))
//                        .frame(width: sliderWidth * 2, height: sliderWidth * 2)
//                        .offset(y: -radius)
//                        .rotationEffect(rotationAngle + Angle(degrees: 18.0))
//                        .gesture(
//                            DragGesture(minimumDistance: 0.0)
//                                .onChanged() { value in
//                                    changeAngle(location: value.location)
//                                    deltat = formatSecondsToHMS(Int((sunset.timeIntervalSince(start) * (0.90 - progress))/0.90))
//                                    slidertime = dateFormatter.string(from: start.addingTimeInterval((sunset.timeIntervalSince(start) * (progress))/0.90))
//                                    // T : 0.90 = C : p
//                                    tapped = true
//                                }
//                        )
//                }
//                .frame(width: radius * 2.0, height: radius * 2.0, alignment: .center)
//                .padding(radius * 0.1)
//            }
//
//            .onAppear {
//                self.rotationAngle = Angle(degrees: progressFraction * 360.0)
//                timepassed = formatSecondsToHMS( Int(currentTime.timeIntervalSince(start)))
//            }
//            .onReceive(timer){ _ in
//                currentTime = Date()
//                timepassed = formatSecondsToHMS( Int(currentTime.timeIntervalSince(start)))
//                if tapped == false{
//                    progress = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
//                        self.rotationAngle = Angle(degrees: progress * 360.0)
//                }
//            }
//        }
//    }
//
//    func formatSecondsToHMS(_ totalSeconds: Int) -> String {
//        let hours = totalSeconds / 3600
//        let minutes = (totalSeconds % 3600) / 60
//        let seconds = (totalSeconds % 3600) % 60
//        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
//    }
//}





struct CircularSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CircularSliderView(pathsJSON: .constant([]), path: PathCustom(title: ""), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), sunset: .now, start: .now, screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.mapView))
    }
}
