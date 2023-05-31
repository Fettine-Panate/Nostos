//
//  ContentView.swift
//  InnerCompass
//
//  Created by Raffaele Martone on 22/05/23.
//
import Foundation
import SwiftUI

struct Marker: Hashable {
    let degrees: Double
    let label: String
    
    init(degrees: Double, label: String = "") {
        self.degrees = degrees
        self.label = label
    }
    
    func degreeText() -> String {
        return String(format: "%.0f", self.degrees)
    }
    
    static func markers() -> [Marker] {
        return [
            Marker(degrees: 0, label: "N"),
            Marker(degrees: 45, label: "NE"),
            Marker(degrees: 90, label: "E"),
            Marker(degrees: 135, label: "SE"),
            Marker(degrees: 180, label: "S"),
            Marker(degrees: 225, label: "SW"),
            Marker(degrees: 270, label: "W"),
            Marker(degrees: 315, label: "NW")
        ]
    }
}

struct CompassMarkerView: View {
    let marker: Marker
    let compassDegress: Double
    
    var body: some View {
        VStack {
            Text(marker.label)
                .rotationEffect(self.textAngle())
                .padding(.bottom, 350 * CGFloat(fontSizerForDevice()))
        }.rotationEffect(Angle(degrees: marker.degrees))
            .animation(.easeInOut, value: marker.degrees)
    }
    
    private func capsuleWidth() -> CGFloat {
        return self.marker.degrees == 0 ? 7 : 3
    }
    
    private func capsuleHeight() -> CGFloat {
        return self.marker.degrees == 0 ? 45 : 30
    }
    
    private func capsuleColor() -> Color {
        return self.marker.degrees == 0 ? .red : .gray
    }
    
    private func textAngle() -> Angle {
        return Angle(degrees: -self.compassDegress - self.marker.degrees)
    }
}

struct CompassView : View {
    @ObservedObject var compassHeading = CompassHeading()
    

    var body: some View {
        
        GeometryReader{ geo in
            ZStack{
                VStack {
                    ZStack {
                        ForEach(Marker.markers(), id: \.self) { marker in
                            CompassMarkerView(marker: marker,
                                              compassDegress: self.compassHeading.degrees )
                            .rotationEffect(Angle(degrees: self.compassHeading.degrees))
                        }
                    }
                    .statusBar(hidden: true)
                }
                .frame(width:  geo.size.width / 2 ,height:  geo.size.height / 2)
            }
            .frame(width:  geo.size.width,height:  geo.size.height)
        }
    }
}


func fontSizerForDevice() -> Float {
    
    if(UIDevice.current.userInterfaceIdiom == .pad){
        return 2.5
    }else{
        return 1
    }
}
