//
//  NotificationManagerDelegate.swift
//  MacroChallengeCode
//
//  Created by Pietro Ciuci on 09/06/23.
//

import Foundation
import UserNotifications

// TODO: Set the correct timeInterval for notification scheduling

enum NotificationActions: String {
    case remind
}

class NotificationManager: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    
    static let shared = NotificationManager()
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    let uuidString = UUID().uuidString
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                // Handle the error
                print(error.localizedDescription)
            }
            if granted {
                print("DEBUG: Notification Allowed")
            } else {
                print("DEBUG: Notification Denied")
            }
        }
    }
    
    func createNotification(title: String, body: String, timeInterval: TimeInterval) {
        
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
                               options: .customDismissAction
        )
        
        center.setNotificationCategories([category])
        
//        scheduleNotification(timeInterval: calculateTimeToReturn(sunset: sunset, startTime: start))
        scheduleNotification(timeInterval: timeInterval)
        
    }
    
    func scheduleNotification(timeInterval: TimeInterval) {
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        
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
            /* In case in the future we are going to implement quick actions */
            let newTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "Nuova notifica"
            content.body = "Questa è una notifica riprogrammata."
            let newNotificationIdentifier = "newNotificationIdentifier"
            let request = UNNotificationRequest(identifier: newNotificationIdentifier, content: content, trigger: newTrigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                if let error = error {
                    print("Errore nell'aggiunta della nuova notifica: \(error.localizedDescription)")
                } else {
                    print("Nuova notifica aggiunta con successo.")
                }
            }
            break
        default:
            print("Default")
            break
        }
        completionHandler()
    }
    
}
