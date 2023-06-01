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
    
    static var minDistance = 5.0
    static var maxDistance = 30.0
    static var maxDeltaTime = 4.0
    
    init() {
        self.locations = []
    }
    
    init(path : PathCustom) {
        for (index, loc) in path.getLocations().enumerated() {
            self.locations.append(loc)
        }
    }

    // Questa funzione lo fa per 10 metri, è una funzione di default per utilizzo rapido
    let checkDistance: (CLLocation, CLLocation) -> Bool = { currentLocation, lastLocation in
        let distance = currentLocation.distance(from: lastLocation)
       // let deltaTime = currentLocation.timestamp.timeIntervalSince(lastLocation.timestamp)
        return distance >= minDistance && distance <= maxDistance
    }
    
    public func getLocations() -> [CLLocation]{
        return locations
    }
    
    public func setMinDistance(min: Double){
        PathCustom.minDistance = min
        PathCustom.maxDistance = min + 20.0
    }
    
    func addLocation(_ location: CLLocation, checkLocation : (CLLocation, CLLocation) -> Bool) {
                if (locations.isEmpty  || checkLocation(location, locations.last ?? CLLocation()))
                    {
                    locations.append(location)
                }
    }
    
    //TODO: removeCheckpoint
    
    public func removeCheckpoint(currentUserLocation: CLLocation) -> Bool{
        var find = false
        let array = locations // Il più lontano è 0
        var ind = 0
        
        for (index, loc) in  array.enumerated(){
            let distance = currentUserLocation.distance(from: loc)
            if distance <= 5.0{
                print(distance)
                ind = index // trovo il ping piu lontano uguale
                find = true
                break
            }
        }
        if find {
            for i in ind ..< locations.count{
                print("dal \(i) a \(locations.count)")
                locations.removeLast()
            }
        }
       
        print("Locations count: \(locations.count)")
        //locations.remove(atOffsets: IndexSet(integer: ind)) // locations sarà da più lontano al più vicino cosi che posso fare il pop
        return find
    }
    
}


