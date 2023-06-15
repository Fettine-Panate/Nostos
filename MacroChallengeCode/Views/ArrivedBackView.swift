//
//  ArrivedBackView.swift
//  MacroChallengeCode
//
//  Created by Francesco De Stasio on 14/06/23.
//

import SwiftUI

struct ArrivedBackView: View {
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                VStack{
                    Image(systemName: "flag.checkered.2.crossed")
                        .resizable()
                        .frame(width: geo.size.width * 0.23, height: geo.size.width * 0.15)
                        .foregroundColor(Color("white"))
                        
                    Text("Congratulation")
                        .bold()
                        .foregroundColor(Color("white"))
                        .font(.system(size: 40))
                        .padding()
                    Text("You arrived at your starting point")
                        .foregroundColor(Color("white"))
                        .font(.system(size: 25))
                }
                .position(x: geo.size.width/2, y: geo.size.height * 0.4)
               
            }
        }
       
    }
}

struct ArrivedBackView_Previews: PreviewProvider {
    static var previews: some View {
        ArrivedBackView()
    }
}
