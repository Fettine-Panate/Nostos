//
//  Path.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import Foundation
import CoreLocation
import CLLocationWrapper


class PathCustom: ObservableObject , Codable {
    
    enum CodingKeys: String, CodingKey {
        case title
        case locations
        // case encodedLocationWrappers
        case response
        
        enum EncodedLocationWrappers: String, CodingKey {
            case encodedLocation
        }
    }
    
    var title : String
    @Published var locations : [CLLocation] = []
    static var encodedLocationWrappers : [CLLocationWrapper] = []
    static var minDistance = 5.0
    static var maxDistance = 30.0
    static var maxDeltaTime = 4.0
    
    init(title: String) {
        self.title = title
        self.locations = []
    }
    
    init(path : PathCustom) {
        self.title = path.title
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
    
    public func getw() -> Int {
        return PathCustom.encodedLocationWrappers.count
    }
    
    public func getTotalDistance() -> Double{
        var b = 0.0
        if locations.count > 1 {
            for i in 0 ..< locations.count{
                if i < (locations.count - 1){
                    let distance = locations[i].distance(from: locations[i+1])
                    b = b + distance
                }
            }
        }
        return b
    }
    
    public func getCenter() -> CLLocation{
        var sumLat = 0.0
        var sumLong = 0.0
        for i in 0 ..< locations.count{
            sumLat = sumLat + locations[i].coordinate.latitude
            sumLong = sumLong + locations[i].coordinate.longitude
        }
        return CLLocation(latitude: sumLat/Double(locations.count), longitude: sumLong/Double(locations.count))
    }
    
    public func getMax() -> Double{
        var max = 0.0
        let center = self.getCenter()
        for i in 0 ..< locations.count{
            let distance = locations[i].distance(from: center)
            if distance > max{
                max = distance
            }
        }
        return max
    }
    
    public func getTotalTime() -> TimeInterval {
        
        if locations.count > 1 {
            return -locations[0].timestamp.timeIntervalSince(locations[locations.count-1].timestamp)
        } else {
            return 0.0
        }
    }
    
    public func setMinDistance(min: Double){
        PathCustom.minDistance = min
        PathCustom.maxDistance = min + 20.0
    }
    
    func addLocation(_ location: CLLocation, checkLocation : (CLLocation, CLLocation) -> Bool) {
        print("Accuracy: \(location.horizontalAccuracy)")
        if (locations.isEmpty  || checkLocation(location, locations.last ?? CLLocation())) && location.horizontalAccuracy <= (PathCustom.minDistance + PathCustom.maxDistance)/2
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
        return find
    }
    
    
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let response = try container.nestedContainer(keyedBy:
//                                                        CodingKeys.self, forKey: .response)
//        self.title = try response.decode(String.self, forKey: .title)
//        var decodedLocationWrapper : [CLLocationWrapper] = []
//        decodedLocationWrapper = try response.decode([CLLocationWrapper].self, forKey: .encodedLocationWrappers)
//        locations.removeAll()
//        for locWr in decodedLocationWrapper{
//            locations.append(locWr.location)
//        }
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        var response = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .response)
//        var locationWrappers : [CLLocationWrapper]? = []
//        for loc in locations {
//            print("appendo")
//            locationWrappers?.append(CLLocationWrapper(location: loc))
//        }
//        try response.encode(self.title, forKey: .title)
//        try response.encode(locationWrappers, forKey: .encodedLocationWrappers)
//    }
    
    
        public required init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
    
            title = try values.decode(String.self, forKey: .title)
            var decodedLocationWrappers : [CLLocationWrapper] = []
    
            let jsonDecoder = try decoder.container(keyedBy: CodingKeys.self)
            do {
                let decodedLocationWrapper = try jsonDecoder.decode([CLLocationWrapper].self, forKey: .locations)
                decodedLocationWrappers.append(contentsOf: decodedLocationWrapper)
            } catch {
                print("Error! Location wrapper decode failed: '\(error)'")
            }
            locations.removeAll()
            for locWr in decodedLocationWrappers{
                locations.append(locWr.location)
            }
        }
    
        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
    
            try container.encode(title, forKey: .title)
//            var locationWrappers : [CLLocationWrapper]? = []
//            for loc in locations {
//                locationWrappers?.append(CLLocationWrapper(location: loc))
//            }
            
            var jsonEncoder = encoder.container(keyedBy: CodingKeys.self)
            do {
                try container.encode(locations, forKey: .locations)
            } catch {
                print("Error! Location wrapper encode failed: '\(error)'")
            }
        }
}

extension CLLocationWrapper{
    subscript(index: String) -> CLLocationWrapper? {
        return nil
    }
}



