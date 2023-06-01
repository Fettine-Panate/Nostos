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
    @State var pins : [Pin] = []
    var currentUserLocation : CLLocation
    @ObservedObject var compassHeading = CompassHeading()
    @ObservedObject var locationManager = LocationManager.shared
    
    var body: some View {
      NavigationView {
          Map(coordinateRegion: $locationManager.region, annotationItems: pins ) { pin in
            
            MapAnnotation(coordinate:pin.location.coordinate) {
                 PinAnnotationView(loc: pin.location)
          }
        }
          .onAppear{
              for loc in path.getLocations() {
                  self.pins.append(Pin(location: loc))
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
        PinsMapView(path: PathCustom(title: "\(Date().description)"), currentUserLocation: CLLocation())
    }
}
