import SwiftUI
import MapKit

struct LocationDetailsView: View {
  let place: Pin
  
  var body: some View {
    VStack(spacing: 20) {
        Text("\(place.location.timestamp)")
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

struct LocationDetailsView_Previews: PreviewProvider {
  static var previews: some View {
      LocationDetailsView(place: Pin(location: CLLocation(latitude: 40.837034, longitude: 14.306127)))
  }
}
