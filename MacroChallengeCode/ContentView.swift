//
//  ContentView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 19/05/23.
//

import SwiftUI
import MapKit
import CoreLocation



struct ContentView: View {
    @State var pathsJSON = itemsJSON
    var body: some View {
        StartView(pathsJSON : $pathsJSON)
    }
        
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
