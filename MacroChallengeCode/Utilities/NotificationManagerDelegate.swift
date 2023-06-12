//
//  NotificationManagerDelegate.swift
//  MacroChallengeCode
//
//  Created by Pietro Ciuci on 09/06/23.
//

import Foundation
import UserNotifications


enum NotificationActions: String {
    case remind
}

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate.self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error
                print(error.localizedDescription)
            }
            if granted {
                print("Notification Allowed")
            } else {
                print("Notification Denied")
            }
        }
    }
    
    func createNotification(title: String, body: String) {
        
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                    (settings.authorizationStatus == .provisional) else { return }
        }
        
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "SUNSET_REMINDER"
        
        let remindAction = UNNotificationAction(identifier: "REMIND_ACTION", title: "Remind me in 10 minutes", options: [])

        let category =
              UNNotificationCategory(identifier: "SUNSET_REMINDER",
              actions: [remindAction],
              intentIdentifiers: [],
              options: []
              )
        
        center.setNotificationCategories([category])
        
        scheduleNotification(timeInterval: 5.0)
        
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([ .sound, .badge])
    }
    
    // Handle selected actions of notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "REMIND_ACTION":
            scheduleNotification(timeInterval: 3) //600
            break
        default:
            print("Dunno mate")
            break
        }
        completionHandler()
    }
    
}
