//
//  Path.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import Foundation
import CoreLocation



class PathCustom: ObservableObject {

    @Published var locations : [CLLocation] = []
    
    
    // Questa funzione lo fa per 10 metri, è una funzione di default per utilizzo rapido
    let checkDistance: (CLLocation, CLLocation) -> Bool = { currentLocation, lastLocation in
        let distance = currentLocation.distance(from: lastLocation)
        return distance >= 5
    }
    
    public func getLocations() -> [CLLocation]{
        return locations
    }
    
    func addLocation(_ location: CLLocation, checkLocation : (CLLocation, CLLocation) -> Bool) {
        if checkLocation(location, locations.last ?? CLLocation()) {
            locations.append(location)
        }
    }
}
