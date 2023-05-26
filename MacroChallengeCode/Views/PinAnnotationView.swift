//
//  PinAnnotationView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 26/05/23.
//

import SwiftUI
import CoreLocation

struct PinAnnotationView: View {
    let loc : CLLocation
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.red)
                .frame(width: 20, height: 20)
            
            Circle()
                .stroke(Color.red, lineWidth: 1)
                .frame(width: 30, height: 30)
        }
//        VStack(spacing: 0) {
//
//            Text(loc.timestamp.formatted(.dateTime))
//                .font(.callout)
//                .padding(5)
//                .background(Color(uiColor: .white))
//                .cornerRadius(10)
//                .foregroundColor(Color(uiColor: .black))
//
//          Image(systemName: "mappin.circle.fill")
//            .font(.title)
//            .foregroundColor(.red)
//
//          Image(systemName: "arrowtriangle.down.fill")
//            .font(.caption)
//            .foregroundColor(.red)
//            .offset(x: 0, y: -5)
//        }
      }
}

struct PinAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        PinAnnotationView(loc: CLLocation(latitude: 10.0, longitude: 10.0))
    }
}
