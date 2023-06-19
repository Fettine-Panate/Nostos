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
                .fill(Color("white"))
                .frame(width: 20, height: 20)
        }
    }
}

struct FirstPinAnnotationView: View {
    let loc : CLLocation
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(
                    Color("white"))
                .frame(width: 13, height: 13)
            
            Circle()
                .stroke(
                    Color("white"), lineWidth: 5)
                .frame(width: 20, height: 20)
        }
    }
}

struct LastPinAnnotationView: View {
    let loc : CLLocation
    var body: some View {
        ZStack{
            Circle()
                .stroke(
                    Color("white"), lineWidth: 5)
                .frame(width: 20, height: 20)
            Image(systemName: "flag.checkered")
                .foregroundColor(
                    Color("white"))
                .font(.largeTitle)
        }
    }
}

struct PinAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LastPinAnnotationView(loc: CLLocation(latitude: 10.0, longitude: 10.0))
    }
}
