import SwiftUI

struct PlaceAnnotationView: View {
  let title: String
  
  var body: some View {
    VStack(spacing: 0) {
      
      Image(systemName: "mappin.circle.fill")
        .font(.title)
        .foregroundColor(.red)
      
      Image(systemName: "arrowtriangle.down.fill")
        .font(.caption)
        .foregroundColor(.red)
        .offset(x: 0, y: -5)
    }
  }
}

struct PlaceAnnotationView_Previews: PreviewProvider {
  static var previews: some View {
    PlaceAnnotationView(title: "Empire State Building")
      .background(Color.gray)
  }
}
