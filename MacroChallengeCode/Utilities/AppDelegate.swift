//
//  AppDelegate.swift
//  MacroChallengeCode
//
//  Created by Pietro Ciuci on 15/06/23.
//

import Foundation
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
        
    func applicationWillTerminate(_ application: UIApplication) {
        // Prevent app to send you push notification if is terminated
        LiveActivityManager.shared.stopActivity()
        NotificationManager.shared.center.removePendingNotificationRequests(withIdentifiers: [NotificationManager.shared.uuidString])
        print("Done!")
    }
    
}
