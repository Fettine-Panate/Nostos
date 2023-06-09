//
//  AppDelegate.swift
//  MacroChallengeCode
//
//  Created by Pietro Ciuci on 07/06/23.
//

import Foundation
import SwiftUI
import ActivityKit

// Used to check if an activity is still active on first launch of the app
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if !Activity<SunsetWidgetAttributes>.activities.isEmpty {
            MapView.stopActivity()
        }
        return true
    }
}
