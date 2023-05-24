//
//  CurrentPositionView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 23/05/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct CurrentPositionView: View {
    
    var body: some View {
        Home()
    }
}

struct CurrentPositionView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentPositionView()
    }
}

struct Home: View{

    @State var tracking : MapUserTrackingMode = .follow

    @State var manager = CLLocationManager()

    @StateObject var managerDelegate = locationDelegate()

    var body: some View {
        VStack{
            HStack{
                Spacer()
               // CompassView(distanceMarkers: 300.0)
            }
            Map(coordinateRegion: $managerDelegate.region, interactionModes:.zoom, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: managerDelegate.pins) { pin in
                MapPin(coordinate: pin.location.coordinate, tint: .red)

            }.edgesIgnoringSafeArea(.all)
        }.onAppear{
            manager.delegate = managerDelegate
        }
    }
}

class locationDelegate: NSObject,ObservableObject,CLLocationManagerDelegate{
    @Published var pins : [Pin] = []

    // From here and down is new
    @Published var location: CLLocation?

    @State var hasSetRegion = false

    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 38.898150, longitude: -77.034340),
        span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
    )

    // Checking authorization status...

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {

        if manager.authorizationStatus == .authorizedWhenInUse{
            print("Authorized")
            manager.startUpdatingLocation()
        } else {
            print("not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // pins.append(Pin(location:locations.last!))

        // From here and down is new
        if let location = locations.last {

            self.location = location

            if hasSetRegion == false{
                region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                hasSetRegion = true
            }
        }
    }
}

// Map pins for update
struct Pin : Identifiable {
    var id = UUID().uuidString
    var location : CLLocation
}
