//
//  PinsMapView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 24/05/23.
//

import SwiftUI
import MapKit

struct Pin: Identifiable {
  let id = UUID()
  var location: CLLocation
}


struct PinsMapView: View {
    let path : PathCustom
    var pins : [Pin] = []

    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.837034, longitude: 14.306127), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    //CLLocation Manager deve calcolare la regione attuale
      
      //Array pin
    init(path: PathCustom) {
        self.path = path
        for loc in path.getLocations() {
            pins.append(Pin(location: loc))
        }
        region = MKCoordinateRegion(center: path.getLocations().last?.coordinate ?? CLLocationCoordinate2D(latitude: 40.837034, longitude: 14.306127), span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    }
    
    var body: some View {
      NavigationView {
        Map(coordinateRegion: $region, annotationItems: pins) { pin in
            MapAnnotation(coordinate:pin.location.coordinate) {
            NavigationLink {
              LocationDetailsView(place: pin)
            } label: {
                PlaceAnnotationView(title: "\(pin.id)")
            }
          }
        }
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Custom Annotation")
        .navigationBarTitleDisplayMode(.inline)
      }
    }
  }

struct PinsMapView_Previews: PreviewProvider {
    static var previews: some View {
        PinsMapView(path: PathCustom())
    }
}
