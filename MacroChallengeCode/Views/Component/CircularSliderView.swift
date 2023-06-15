//
//  CircularSliderView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 06/06/23.
//

import SwiftUI
import CoreLocation

let dateFormatterHHMM: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
}()


struct CircularSliderView: View {
    @Binding var pathsJSON : [PathCustom]
    @ObservedObject var path : PathCustom
    @Binding var userLocation : CLLocation?
    @State var progress1 = 0.0
    @State var dragged = false
    let sunset : Date
    let start : Date
    @State var tapped = false
    @State var currentTime =  Date()
    @State var pastTime = 0.0
    @State var currentPosition : CGPoint?
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Binding var screen : Screens
    @Binding var activity : ActivityEnum
    @Binding var mapScreen : MapSwitch
    
    var ns: Namespace.ID
    
    let day : dayFase
    
    init(pathsJSON: Binding<[PathCustom]>, path: PathCustom, userLocation : Binding<CLLocation?>, progress1: Double = 0.0, sunset: Date, start: Date, screen : Binding<Screens>,activity: Binding<ActivityEnum>,  mapScreen: Binding<MapSwitch>, namespace: Namespace.ID, day: dayFase) {
        self.sunset = sunset
        self.start = start
        self._screen = screen
        self.ns = namespace
        self._mapScreen = mapScreen
        self._activity = activity
        self.path = path
        self._userLocation = userLocation
        self._pathsJSON = pathsJSON
        self.day = day
    }
    @State var isBeforeTheSunset = true
    
    @State var progress : Double = 0.0
    @State var rotationAngle : Angle = Angle(degrees: 0.0)
    @State var remaingTimeToSunset : Int = 0 //seconds
    @State var dateOfAvatarPosition : Date = Date()
    
    
    var body: some View {
        let currentTimeIndex = Int(dateFormatter.string(from: Date()))
        
        GeometryReader{ gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0)  * 0.9
            let sliderWidth = 17.0
            ZStack {
                //Cerchio interno
                Circle()
                    .trim(from: 0, to: 0.9)
                    .stroke(Color.black.opacity(day.hours[currentTimeIndex!].accentObjectOp),
                            style: StrokeStyle(lineWidth: sliderWidth,lineCap: .round))
                    .rotationEffect(Angle(degrees: 108))
                    .frame(width: radius * 2, height: radius * 2)
                    .position(x: gr.size.width * 0.5, y: gr.size.height * 0.5)
                //Cerchio progress
                Circle()
                    .trim(from: !dragged ? 0 : progress, to: !dragged ? progress : 0.9)
                    .stroke(Color("white"),
                            style: StrokeStyle(lineWidth: sliderWidth,lineCap: .round))
                    .rotationEffect(Angle(degrees: 108))
                    .matchedGeometryEffect(id: "circle", in: ns)
                    .matchedGeometryEffect(id: "circle1", in: ns)
                    .matchedGeometryEffect(id: "circle2", in: ns)
                    .matchedGeometryEffect(id: "circle3", in: ns)
                    .matchedGeometryEffect(id: "circle4", in: ns)
                    .frame(width: radius * 2, height: radius * 2)
                    .overlay {
                        Text("")
                    }
                    .position(x: gr.size.width * 0.5, y: gr.size.height * 0.5)
                    .animation(.easeInOut(duration: 0.4), value: dragged)
                
                Avatar()
                    .matchedGeometryEffect(id: "avatar", in: ns)
                    .foregroundColor(Color("white"))
                    .offset(x:sin(18 * Double.pi / 180) * -radius , y: cos(18 * Double.pi / 180) * radius)
                    .rotationEffect(  rotationAngle
                    )
                    .animation(.easeInOut(duration: 0.4), value: dragged)
                    .gesture(
                        DragGesture(minimumDistance: 0.0)
                            .onChanged(){ value in
                                if isBeforeTheSunset{
                                    dragged = true
                                    let minAngle = calculateAngleFromDate(sunsetTime: sunset, startTime: start, inputTime: .now)
                                    progress = changeProgress(value: value.location, progress: progress, minAngle: minAngle)
                                    rotationAngle = changeAngle(value: value.location, currentAngle: rotationAngle, minAngle: minAngle)
                                    remaingTimeToSunset = Int((sunset.timeIntervalSince(start) * progress) / 0.9)
                                    dateOfAvatarPosition = start.addingTimeInterval(Double(remaingTimeToSunset))
                                }
                                
                            }
                            .onEnded(){_ in
                                if isBeforeTheSunset{
                                    dragged = false
                                }
                            }
                    )
                iconSlider(text: Text(dateFormatterHHMM.string(from: start)),angle: Angle(degrees: 18.0) , radius: radius)
                    .rotationEffect(Angle(degrees: 18))
                    .opacity(day.hours[currentTimeIndex!].accentObjectOp + 0.1)
                iconSlider(icon: Image(systemName: "exclamationmark.triangle.fill"),angle: calculateAngleFromDate(sunsetTime: sunset, startTime: start, inputTime: calculateDateToReturn(sunset: sunset, startTime: start)) , radius: radius)
                    .rotationEffect( calculateAngleFromDate(sunsetTime: sunset, startTime: start, inputTime: calculateDateToReturn(sunset: sunset, startTime: start)))
                    .opacity(day.hours[currentTimeIndex!].accentObjectOp + 0.1)
                iconSlider(icon: Image(systemName: "sunset.fill"), text: Text( dateFormatterHHMM.string(from: sunset))
                           ,angle: Angle(degrees: 342) , radius: radius)
                .rotationEffect(Angle(degrees: 342))
                .opacity(day.hours[currentTimeIndex!].accentObjectOp + 0.1)
                
                //            iconSlider(icon: Image(systemName: "sunset") ,angle: Angle(degrees: 312) , radius: radius)
                //                .rotationEffect(Angle(degrees: 312))
                //                .opacity(day.hours[currentTimeIndex!].accentObjectOp + 0.1)
                if isBeforeTheSunset{
                    if dragged{
                        iconSlider(text:
                                    Text(dateFormatterHHMM.string(from: dateOfAvatarPosition)).bold().foregroundColor(Color("white")),angle: rotationAngle + Angle(degrees: 18) , radius: radius, rect: false)
                        .rotationEffect(rotationAngle + Angle(degrees: 18))
                        //.opacity(day.hours[currentTimeIndex!].accentObjectOp + 0.1)
                    }
                    if !dragged{
                        VStack {
                            Text("Activity time:")
                                .font(.system(size: 25, design: .rounded))
                            Text(formatSecondsToHMS(Int(pastTime)))
                                .font(.system(size: 30, design: .rounded))
                                .bold()
                        }
                        .multilineTextAlignment(.center)
                        .position(x: gr.size.width * 0.5, y: gr.size.height * 0.1)
                        .foregroundColor(Color("white"))
                    } else {
                        VStack {
                            Text("Time to sunset:")
                                .font(.system(size: 25, design: .rounded))
                            Text((formatSecondsToHM(Int(sunset.timeIntervalSince(dateOfAvatarPosition)))))
                                .font(.system(size: 30, design: .rounded))
                                .bold()
                        }
                        .multilineTextAlignment(.center)
                        .position(x: gr.size.width * 0.5, y: gr.size.height * 0.1)
                        .foregroundColor(Color("white"))
                    }
                }else{
                    VStack {
                        Text("Activity time:")
                            .font(.system(size: 25, design: .rounded))
                        Text(formatSecondsToHMS(Int(pastTime)))
                            .font(.system(size: 30, design: .rounded))
                            .bold()
                    }
                    .multilineTextAlignment(.center)
                    .position(x: gr.size.width * 0.5, y: gr.size.height * 0.1)
                    .foregroundColor(Color("white"))
                }
                
            }
            .onChange(of: userLocation) { newValue in
                path.addLocation(userLocation!, checkLocation: path.checkDistance)
                pathsJSON.removeLast()
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
        }
        .onAppear(){
            pastTime = currentTime.timeIntervalSince(start)
            if sunset.timeIntervalSince(currentTime) <= 0{
                isBeforeTheSunset = false
            }
        }
        .onReceive(timer){ _ in
            currentTime = Date()
            if sunset.timeIntervalSince(currentTime) <= 0{
                isBeforeTheSunset = false
            }
            pastTime = currentTime.timeIntervalSince(start)
            if isBeforeTheSunset{
                if !dragged{
                    withAnimation(.linear(duration: 5)){
                        progress = (0.90 * currentTime.timeIntervalSince(start)) / sunset.timeIntervalSince(start)
                        rotationAngle = calculateAngleFromDate(sunsetTime: sunset, startTime: start, inputTime: currentTime)
                    }
                }
            } else{
                progress = 0.90
                rotationAngle = Angle(degrees: 0.90 * 360)
            }
            
        }
    }
}

func formatSecondsToHMS(_ totalSeconds: Int) -> String {
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    let seconds = (totalSeconds % 3600) % 60
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

func formatSecondsToHM(_ totalSeconds: Int) -> String {
    let hours = totalSeconds / 3600
    let minutes = (totalSeconds % 3600) / 60
    return String(format: "%02d:%02d:00", hours, minutes)
}


func calculateAngleFromDate(sunsetTime: Date, startTime: Date, inputTime: Date)-> Angle{
    
    let x = inputTime.timeIntervalSince(startTime)/sunsetTime.timeIntervalSince(startTime)
    return Angle(degrees: x * 360)
    
}

func calculateDateToReturn(sunset: Date, startTime: Date) -> Date{
    let ret = startTime.addingTimeInterval(sunset.timeIntervalSince(startTime)/2)
    return ret
}

func calculateTimeToReturn(sunset: Date, startTime: Date) -> TimeInterval{
    let ret = sunset.timeIntervalSince(startTime)/2
    return ret
}

func changeProgress(value: CGPoint, progress : Double, minAngle : Angle) -> Double {
    let vector = CGVector(dx: -value.x, dy: value.y)
    let angleRadians = atan2(vector.dx, vector.dy)
    let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
    var ret : Double = progress
    if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >= minAngle  {
        ret = ((positiveAngle / ((2.0 * .pi))))
    }
    print("returning : \(ret)")
    return ret
}

func changeAngle(value: CGPoint,currentAngle: Angle, minAngle : Angle) -> Angle {
    let vector = CGVector(dx: -value.x, dy: value.y)
    let angleRadians = atan2(vector.dx, vector.dy)
    let positiveAngle = angleRadians < 0.0 ? angleRadians + (2.0 * .pi) : angleRadians
    var ret : Angle = currentAngle
    if Angle(radians: positiveAngle) <= Angle(degrees: 324) && Angle(radians: positiveAngle) >=  minAngle {
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


struct iconSlider : View {
    
    var icon : Image?
    var text : Text?
    
    var angle : Angle
    var radius : Double
    var rect : Bool?
    
    init(icon: Image? = nil, text: Text? = nil, angle: Angle, radius: Double, rect: Bool? = true) {
        self.icon = icon
        self.text = text
        self.angle = angle
        self.radius = radius
        self.rect = rect
    }
    
    
    var body: some View{
        VStack{
            if rect! {
                Rectangle()
                    .frame(width: 3,height: 10)
                    .cornerRadius(10)
            }
            VStack{
                if (icon == nil){
                    text.padding(5)
                        .bold()
                }else{
                    icon.padding(5)
                }
            }.rotationEffect(-angle)
        }
        .offset(y: radius * 1.45)
        
        
    }
}


struct CircularSliderView_Previews: PreviewProvider {
    static var previews: some View {
        CircularSliderView(pathsJSON: .constant([]), path: PathCustom(title: ""), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), sunset: .now, start: .now, screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.mapView), namespace: Namespace.init().wrappedValue, day: dayFase(sunrise: 06, sunset: 20))
    }
}
