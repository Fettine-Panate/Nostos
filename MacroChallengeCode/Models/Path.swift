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
    }
    
    var title : String
    @Published var locations : [CLLocation] = []
    static var encodedLocationWrapper : [Data] = []
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

    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        title = try values.decode(String.self, forKey: .title)
        
        var decodedLocationWrapper : [CLLocationWrapper] = []
        let jsonDecoder = JSONDecoder()
        do {
            
            for index in 0 ..< PathCustom.encodedLocationWrapper.count {
                decodedLocationWrapper.append(try jsonDecoder.decode(CLLocationWrapper.self, from: PathCustom.encodedLocationWrapper[index]))
            }
        } catch {
            print("Error! Location wrapper decode failed: '\(error)'")
        }
        
        locations.removeAll()
        for locWr in decodedLocationWrapper{
            locations.append(locWr.location)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var locationWrappers : [CLLocationWrapper] = []
        for loc in locations {
            locationWrappers.append(CLLocationWrapper(location: loc))
        }
        let jsonEncoder = JSONEncoder()
        do {
           
            for locWr in locationWrappers {
                PathCustom.encodedLocationWrapper.append(try jsonEncoder.encode(locWr.location))
            }
        } catch {
            print("Error! Location wrapper encode failed: '\(error)'")
        }
    }
    
  
    
}



