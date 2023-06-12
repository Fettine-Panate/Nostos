//
//  DayFase.swift
//  MacroChallengeCode
//
//  Created by Raffaele Martone on 30/05/23.
//

import Foundation
import SwiftUI

struct dayFase{
    
    var hours : [hour]
    
    init(sunrise: Int, sunset : Int) {
        
        var b : [hour] = []
        for(index) in 0..<24 {
            if index < sunrise{
                let buf = hour(hour: index, color: "night", accentObjectOp: 0.25 )
                b.append(buf)
            } else if index == sunrise{
                let buf = hour(hour: index, color: "sunrise", accentObjectOp: 0.05 )
                b.append(buf)
            }else{
                if index < 11{
                    let buf = hour(hour: index, color: "morning1", accentObjectOp: 0.05 )
                    b.append(buf)
                } else if index == 11 {
                    let buf = hour(hour: index, color: "morning2", accentObjectOp: 0.05 )
                    b.append(buf)
                } else if index == 12 {
                    let buf = hour(hour: index, color: "midday", accentObjectOp: 0.05  )
                    b.append(buf)
                } else if index == 13 {
                    let buf = hour(hour: index, color: "after1", accentObjectOp: 0.05  )
                    b.append(buf)
                } else if index == 14 {
                    let buf = hour(hour: index, color: "after1", accentObjectOp: 0.05  )
                    b.append(buf)
                } else{
                    if index < sunset{
                        let buf = hour(hour: index, color: "after2", accentObjectOp: 0.05  )
                        b.append(buf)
                    } else if index == sunset {
                        let buf = hour(hour: index, color: "sunset", accentObjectOp: 0.10 )
                        b.append(buf)
                    } else if index == (sunset  + 1) {
                        let buf = hour(hour: index, color: "sunset2", accentObjectOp: 0.15 )
                        b.append(buf)
                    }  else if index == (sunset  + 2) {
                        let buf = hour(hour: index, color: "sunset3", accentObjectOp: 0.15 )
                        b.append(buf)
                    } else if index > (sunset  + 2) {
                        let buf = hour(hour: index, color: "night", accentObjectOp: 0.25 )
                        b.append(buf)
                    }
                }
            }
        }
        self.hours = b
    }
}

struct hour{
    var hour : Int
    var color : String
    var accentObjectOp : Double
}
