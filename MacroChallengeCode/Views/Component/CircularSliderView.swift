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
    let eveningGoldenHourEnd : Date
    @State var tapped = false
    @State var currentTime =  Date()
    @State var pastTime : TimeInterval = 0.0
    @State var currentPosition : CGPoint?
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @Binding var screen : Screens
    @Binding var activity : ActivityEnum
    @Binding var mapScreen : MapSwitch
    
    var ns: Namespace.ID
    
    let day : DayPhase
    @Binding var dateOfAvatarPosition : Date
    
    init(pathsJSON: Binding<[PathCustom]>, path: PathCustom, userLocation : Binding<CLLocation?>, progress1: Double = 0.0, sunset: Date, start: Date, eveningGoldenHourEnd: Date , screen : Binding<Screens>,activity: Binding<ActivityEnum>,  mapScreen: Binding<MapSwitch>, namespace: Namespace.ID, day: DayPhase, dateOfAvatarPosition: Binding<Date>) {
        self.sunset = sunset
        self.start = start
        self.eveningGoldenHourEnd = eveningGoldenHourEnd
        self._screen = screen
        self.ns = namespace
        self._mapScreen = mapScreen
        self._activity = activity
        self.path = path
        self._userLocation = userLocation
        self._pathsJSON = pathsJSON
        self.day = day
        self._dateOfAvatarPosition = dateOfAvatarPosition
        if path.locations.isEmpty{
            self.pastTime = 0.0
        }
        else{
            self.pastTime = Date().timeIntervalSince(path.locations[0].timestamp)
        }
    }
    @State var isBeforeTheEveningGoldenHourEnd = true
    @State var isNight = false
    @State var progress : Double = 0.0
    @State var rotationAngle : Angle = Angle(degrees: 0.0)
    @State var remaingTimeToEveningGoldenHourEnd : Int = 0 //seconds
    
    
    var body: some View {
        
        GeometryReader{ gr in
            let radius = (min(gr.size.width, gr.size.height) / 2.0) // * 0.9
            let sliderWidth = 17.0
            ZStack {
                //Cerchio interno
                Circle()
                    .trim(from: 0, to: 0.9)
                    .stroke(Color.black.opacity(day.getClosestPhase(currentTime: Date()).color.accentObjectOp),
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
                                if isBeforeTheEveningGoldenHourEnd{
                                    dragged = true
                                    let minAngle = calculateAngleFromDate(eveningGoldenHourEndTime: eveningGoldenHourEnd, startTime: start, inputTime: .now)
                                    progress = changeProgress(value: value.location, progress: progress, minAngle: minAngle)
                                    rotationAngle = changeAngle(value: value.location, currentAngle: rotationAngle, minAngle: minAngle)
                                    remaingTimeToEveningGoldenHourEnd = Int((eveningGoldenHourEnd.timeIntervalSince(start) * progress) / 0.9)
                                    dateOfAvatarPosition = start.addingTimeInterval(Double(remaingTimeToEveningGoldenHourEnd))
                                }
                                
                            }
                            .onEnded(){_ in
                                if isBeforeTheEveningGoldenHourEnd{
                                    dragged = false
                              
                                        dateOfAvatarPosition = Date()
                                  
                                }
                            }
                    )
                iconSlider(text: Text(dateFormatterHHMM.string(from: start)),angle: Angle(degrees: 18.0) , radius: radius)
                    .rotationEffect(Angle(degrees: 18))
                    .foregroundColor(!isNight ? Color.black.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1) : Color.white.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1))
                iconSlider(icon: Image(systemName: "exclamationmark.triangle.fill"),angle: calculateAngleFromDate(eveningGoldenHourEndTime: eveningGoldenHourEnd, startTime: start, inputTime: calculateDateToReturn(eveningGoldenHourEnd: eveningGoldenHourEnd, startTime: start)) , radius: radius)
                    .rotationEffect( calculateAngleFromDate(eveningGoldenHourEndTime: eveningGoldenHourEnd, startTime: start, inputTime: calculateDateToReturn(eveningGoldenHourEnd: eveningGoldenHourEnd, startTime: start)))
                .foregroundColor(!isNight ? Color.black.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1) : Color.white.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1))
                iconSlider(icon: Image(systemName: "sunset.fill"), text: Text( dateFormatterHHMM.string(from: eveningGoldenHourEnd))
                           ,angle: calculateAngleFromDate(eveningGoldenHourEndTime: eveningGoldenHourEnd, startTime: start, inputTime: sunset) , radius: radius)
                .rotationEffect(calculateAngleFromDate(eveningGoldenHourEndTime: eveningGoldenHourEnd, startTime: start, inputTime: sunset))
                .foregroundColor(!isNight ? Color.black.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1) : Color.white.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1))
                iconSlider( icon: Image(systemName: "moon.stars.fill"),angle: Angle(degrees: 342) , radius: radius)
                .rotationEffect(Angle(degrees: 342))
                .foregroundColor(!isNight ? Color.black.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1) : Color.white.opacity(day.getClosestPhase(currentTime: dateOfAvatarPosition).color.accentObjectOp + 0.1))
                if isBeforeTheEveningGoldenHourEnd{
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
                        .position(CGPoint(x: gr.size.width/2, y: gr.size.height * 1/40))
                        .foregroundColor(Color("white"))
                    } else {
                        VStack {
                            Text(LocalizedStringKey(".TimeToSunset"))
                                .font(.system(size: 25, design: .rounded))
                            Text((Int(sunset.timeIntervalSince(dateOfAvatarPosition))) < 0 ? "00:00:00" : formatSecondsToHM(Int(sunset.timeIntervalSince(dateOfAvatarPosition))))
                                .font(.system(size: 30, design: .rounded))
                                .bold()
                        }
                        .multilineTextAlignment(.center)
                        .position(CGPoint(x: gr.size.width/2, y: gr.size.height * 1/40))
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
                    .position(CGPoint(x: gr.size.width/2, y: gr.size.height * 1/40))
                    .foregroundColor(Color("white"))
                }
                
            }
            .onChange(of: userLocation) { newValue in
                path.addLocation(userLocation!, checkLocation: path.checkDistance)
                pathsJSON.removeLast()
                pathsJSON.append(path)
                savePack("Paths", pathsJSON)
            }
            .onChange(of: dateOfAvatarPosition) { newValue in
                if isBeforeTheEveningGoldenHourEnd {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "HH"
                }
            }
        }
        .onAppear(){
            pastTime = currentTime.timeIntervalSince(start)
            if eveningGoldenHourEnd.timeIntervalSince(currentTime) <= 0{
                isBeforeTheEveningGoldenHourEnd = false
            }
            if day.getClosestPhase(currentTime: dateOfAvatarPosition).name == "Night"{
                isNight = true
            }else{
                isNight = false
            }
        }
        .onReceive(timer){ _ in
            currentTime = Date()
            if eveningGoldenHourEnd.timeIntervalSince(currentTime) <= 0{
                isBeforeTheEveningGoldenHourEnd = false
            }
            pastTime = currentTime.timeIntervalSince(start)
            if isBeforeTheEveningGoldenHourEnd{
                if !dragged{
                    withAnimation(.linear(duration: 5)){
                        progress = (0.90 * currentTime.timeIntervalSince(start)) / eveningGoldenHourEnd.timeIntervalSince(start)
                        rotationAngle = calculateAngleFromDate(eveningGoldenHourEndTime: eveningGoldenHourEnd, startTime: start, inputTime: currentTime)
                    }
                }
            } else{
                progress = 0.90
                rotationAngle = Angle(degrees: 0.90 * 360)
            }
                if day.getClosestPhase(currentTime: dateOfAvatarPosition).name == "Night"{
                    isNight = true
                }else{
                    isNight = false
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


func calculateAngleFromDate(eveningGoldenHourEndTime: Date, startTime: Date, inputTime: Date)-> Angle{
  
    let x = inputTime.timeIntervalSince(startTime)/eveningGoldenHourEndTime.timeIntervalSince(startTime)
    return Angle(degrees: x * 342)
    
}

func calculateDateToReturn(eveningGoldenHourEnd: Date, startTime: Date) -> Date{
    let ret = startTime.addingTimeInterval(eveningGoldenHourEnd.timeIntervalSince(startTime)/2)
    return ret
}

func calculateTimeToReturn(eveningGoldenHourEnd: Date, startTime: Date) -> TimeInterval{
    let ret = eveningGoldenHourEnd.timeIntervalSince(startTime)/2
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
        .offset(y: radius * 1.35)
        
        
    }
}


//struct CircularSliderView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircularSliderView(pathsJSON: .constant([]), path: PathCustom(title: ""), userLocation: .constant(CLLocation(latitude: 14.000000, longitude: 41.000000)), sunset: .now, start: .now, screen: .constant(.activity), activity: .constant(.sunset), mapScreen: .constant(.mapView), namespace: Namespace.init().wrappedValue, day: dayFase(sunrise: 06, sunset: 20))
//    }
//}
