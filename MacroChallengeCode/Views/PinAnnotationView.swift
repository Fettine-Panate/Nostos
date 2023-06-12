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
                .stroke(
                    Color("white"), lineWidth: 3)
                .frame(width: 30, height: 30)
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
                .frame(width: 20, height: 20)
            
            Circle()
                .stroke(
                    Color("white"), lineWidth: 3)
                .frame(width: 30, height: 30)
        }
    }
}

struct LastPinAnnotationView: View {
    let loc : CLLocation
    var body: some View {
        ZStack{
            Circle()
                .stroke(
                    Color("white"), lineWidth: 3)
                .frame(width: 30, height: 30)
            Image(systemName: "flag.checkered")
                .foregroundColor(
                    Color("white"))
                .frame(width: 60, height: 60)
        }
    }
}

struct PinAnnotationView_Previews: PreviewProvider {
    static var previews: some View {
        LastPinAnnotationView(loc: CLLocation(latitude: 10.0, longitude: 10.0))
    }
}
