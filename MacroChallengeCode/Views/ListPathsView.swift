//
//  ListPathsView.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 01/06/23.
//

import SwiftUI

struct ListPathsView: View {
    let paths : [PathCustom]
    @State var arr = Array(stride(from: 0, to: 1 , by: 1))
    
    var body: some View {
        NavigationView{
            List{
                ForEach(arr, id: \.self ){ i in
                    NavigationLink(destination: RecapPathView(path: paths[i]) ) {
                        Text(paths[i].title)
                    }
                }
            }
            .navigationTitle("List of Paths")
            .onAppear(){
                arr = Array(stride(from: 0, to: paths.count , by: 1))
            }
        }
    }
}

//
//struct ListPathsView_Previews: PreviewProvider {
//    static var previews: some View {
//        ListPathsView()
//    }
//}
