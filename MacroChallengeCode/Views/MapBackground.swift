//
//  MapBackground.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import SwiftUI
import MapKit

struct MapBackground: View {
    var body: some View {
        ZStack {
            CompassView()
            Circle()
                .stroke(Color.gray, lineWidth: 0.3)
                .frame(width: 300, height: 300)
                
            Circle()
                .stroke(Color.gray, lineWidth: 0.3)
                .frame(width: 500, height: 500)
            
            Circle()
                .stroke(Color.gray, lineWidth: 0.3)
                .frame(width: 700, height: 700)
        }
    }
}

struct MapBackground_Previews: PreviewProvider {
    static var previews: some View {
        MapBackground()
    }
}
