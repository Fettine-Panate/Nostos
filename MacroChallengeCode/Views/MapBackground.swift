//
//  MapBackground.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 23/05/23.
//

import SwiftUI
import MapKit

struct MapBackground: View {
    var size : CGSize
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: size.height/4, height: size.height/4)
            
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: (2 * size.height)/4, height: (2 * size.height)/4)
            
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: (3 * size.height)/4, height: (3 * size.height)/4)
            
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: size.height, height: size.height)
            
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: size.height * 5/4, height: size.height * 5/4)
            
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: size.height * 6/4, height: size.height * 6/4)
            
            Circle()
                .stroke(Color.black.opacity(0.2), lineWidth: 15)
                .frame(width: size.height * 7/4, height: size.height * 7/4)
        }
    }
}

struct MapBackground_Previews: PreviewProvider {
    static var previews: some View {
        MapBackground(size: CGSize(width: 393.0, height: 759.0))
    }
}
