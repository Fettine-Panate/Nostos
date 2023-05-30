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
    @Published var comingBack = false
    
    
    static var minDistance = 5.0
    static var maxDistance = 30.0
    static var maxDeltaTime = 4.0
    
    // Questa funzione lo fa per 10 metri, è una funzione di default per utilizzo rapido
    let checkDistance: (CLLocation, CLLocation) -> Bool = { currentLocation, lastLocation in
        let distance = currentLocation.distance(from: lastLocation)
        let deltaTime = currentLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
        return distance >= minDistance && distance <= maxDistance
    }
    
    public func getLocations() -> [CLLocation]{
        return locations
    }
    
    
    public func isComingBack() -> Bool{
        return comingBack
    }
    
    public func setComingBack(comingBack: Bool){
        self.comingBack = comingBack
    }
    
    func addLocation(_ location: CLLocation, checkLocation : (CLLocation, CLLocation) -> Bool) {
        if checkLocation(location, locations.last ?? CLLocation()) {
            locations.append(location)
        }
    }
    
    //TODO: removeCheckpoint
    
    public func removeCheckpoint(currentUserLocation: CLLocation){
        let array = locations.reversed()
        var ind = 0
        if comingBack{
            for (index, loc) in  array.enumerated(){
                if currentUserLocation.distance(from: loc) <= 5.0{
                    ind = locations.count - index
                    break
                }
            }
            locations.remove(atOffsets: IndexSet(integer: ind))
        }
        
    }
    
}


