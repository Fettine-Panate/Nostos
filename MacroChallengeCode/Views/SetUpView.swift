//
//  SetUpView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 30/05/23.
//

import SwiftUI

struct SetUpView: View {
    @State private var selectedValue = 5.0
    let minimumValue = 5
    let maximumValue = 15

    var body: some View {
        VStack {
            Text("Selected Value: \(selectedValue)")
                .font(.headline)

            Picker("Value", selection: $selectedValue) {
                ForEach(minimumValue...maximumValue, id: \.self) { value in
                    Text("\(value)")
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(width: 150, height: 200)
        }
        .padding()
        NavigationLink(destination: StartView(selectedMetres: selectedValue), label: {
            Text("Done")
        })
    }
}

struct SetUpView_Previews: PreviewProvider {
    static var previews: some View {
        SetUpView()
    }
}
