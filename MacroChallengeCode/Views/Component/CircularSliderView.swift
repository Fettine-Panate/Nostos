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
                if isBeforeTheSunset{
                    if dragged{
                        iconSlider(text:
                                    Text(dateFormatterHHMM.string(from: dateOfAvatarPosition)).bold().foregroundColor(Color("white")),angle: rotationAngle + Angle(degrees: 18) , radius: radius, rect: false)
                        .rotationEffect(rotationAngle + Angle(degrees: 18))
                    }
                    if !dragged{
                        VStack {
                            Text(LocalizedStringKey(".ActivityTime"))
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
                            Text(LocalizedStringKey(".TimeToSunset"))
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
