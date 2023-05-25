//
//  MapView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 25/05/23.
//

import SwiftUI
import CoreLocation

struct MapView: View {
    var path : PathCustom
    var currentUserLocation : CLLocation
    
    
    var body: some View {
        GeometryReader { geometry in
                 ZStack {
                     ForEach(path.getLocations(), id: \.self ){ loc in
                         let position = calculatePosition(for: loc, in: geometry.size)
                         Text("\(loc.timestamp)")
                             .position(position)
                     }
                 }
             }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(path: PathCustom(), currentUserLocation: CLLocation(latitude: 40.837034, longitude: 14.306127))
    }
}

struct Constants {
    static let minLatitude = -90.0
    static let maxLatitude = 90.0
    static let minLongitude = -180.0
    static let maxLongitude = 180.0
}


private func calculatePosition(for element: CLLocation, in size: CGSize) -> CGPoint {
    let latitudeRatio = (element.coordinate.latitude - Constants.minLatitude) / (Constants.maxLatitude - Constants.minLatitude)
    let longitudeRatio = (element.coordinate.longitude - Constants.minLongitude) / (Constants.maxLongitude - Constants.minLongitude)
       
       let x = longitudeRatio * size.width
       let y = latitudeRatio * size.height
       
       return CGPoint(x: x, y: y)
    
}
