import SwiftUI
import MapKit

struct LocationDetailsView: View {
  let place: Pin
  
  var body: some View {
    VStack(spacing: 20) {
      Text("\(place.id)")
        .font(.title)
      
        Text(place.location.coordinate.description)
        .font(.title2)
    }
    .navigationTitle("\(place.id)")
  }
}

extension CLLocationCoordinate2D: CustomStringConvertible {
  public var description: String {
    "\(latitude);\(longitude)"
  }
}

//struct LocationDetailsView_Previews: PreviewProvider {
//  static var previews: some View {
//    LocationDetailsView(place: Place(name: "Empire State Building", coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0)))
//  }
//}
