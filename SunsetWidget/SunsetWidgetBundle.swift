//
//  SunsetWidgetBundle.swift
//  SunsetWidget
//
//  Created by Pietro Ciuci on 31/05/23.
//

import WidgetKit
import SwiftUI

@main
struct SunsetWidgetBundle: WidgetBundle {
    var body: some Widget {
        SunsetWidget()
        SunsetWidgetLiveActivity()
    }
}
