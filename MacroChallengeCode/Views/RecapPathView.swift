//
//  RecapPathView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 01/06/23.
//

import SwiftUI

struct RecapPathView: View {
    let path : PathCustom
    @State var numberOfPins : Int = 0
    @State var distance : Double = 0.0
    @State var deltaTime : TimeInterval = 0.0
    
    
    var body: some View {
        GeometryReader{ geo in
            VStack{
                VStack{
                    ForEach(path.getLocations(), id: \.self ){ loc in
                        let position = calculatePosition(loc: loc, currentLocation: path.getCenter(), sizeOfScreen: CGSize(width: geo.size.width, height: geo.size.height/2), latitudeMetersMax: path.getMax())
                        PinAnnotationView(loc: loc)
                            .position(position)
                            .animation(.linear, value: position)
                            .scaleEffect(0.1)
                    }
                }.cornerRadius(10)
                .overlay{
                    ZStack{
                        Color.red.opacity(0.2)
                        withAnimation{
                            Path { pat in
                                for (index, loc) in path.getLocations().enumerated() {
                                    let point = calculatePosition(loc: loc, currentLocation: path.getCenter(), sizeOfScreen: CGSize(width: geo.size.width, height: geo.size.height * 2/3), latitudeMetersMax: path.getMax())
                                    if index == 0 {
                                        pat.move(to: point)
                                    } else {
                                        pat.addLine(to: point)
                                    }
                                }
                            }
                        }
                        .stroke(Color.red, lineWidth: 2 * 0.1)
                        .scaleEffect(0.1)
                    }.cornerRadius(10)
                }
                .frame(height: geo.size.height * 2/3)
                VStack{
                    HStack{
                        Text("Date: \(path.title)")
                        Spacer()
                    }
                    HStack{
                        Text("W: \(path.getw())")
                        Spacer()
                    }
                    HStack{
                        Text("Numbers of pins: \(numberOfPins)")
                        Spacer()
                    }
                    HStack{
                        Text("Total distance: \(distance)")
                        Spacer()
                    }
                    HStack{
                        Text("Total time: \(deltaTime)")
                        Spacer()
                    }
                }.frame(height: geo.size.height/3)
            }
        }
        .navigationTitle(path.title)
        .onAppear(){
            numberOfPins = path.getLocations().count
            distance = path.getTotalDistance()
            deltaTime = path.getTotalTime()
        }
    }
}

//
//struct RecapPathView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecapPathView(path: PathCustom(title: "Ciao"))
//    }
//}
