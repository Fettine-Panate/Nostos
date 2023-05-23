//
//  LocationRequestView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 22/05/23.
//

import SwiftUI

struct LocationRequestView: View {
    var body: some View {
        ZStack{
            Color(.blue).ignoresSafeArea()
            VStack{
                Text("Would you like to explore places nearby?")
                    .font(.system(size: 28, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.white)
                Spacer()
                VStack{
                    Button{
                        LocationManager.shared.requestLocation()
                        print("Request from the user")
                    } label: {
                        Text("Allow Location")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.blue)
                    }.background(){
                        Color.white
                    }
                    Button{
                        print("Dismiss")
                    } label: {
                        Text("Maybe Later")
                            .padding()
                            .font(.headline)
                            .foregroundColor(.blue)
                    }.background(){
                        Color.white
                    }
                }
            }
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
