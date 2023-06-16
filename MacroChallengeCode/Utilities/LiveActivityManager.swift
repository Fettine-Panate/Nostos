//
//  ActivityManagerDelegate.swift
//  MacroChallengeCode
//
//  Created by Pietro Ciuci on 09/06/23.
//

import Foundation
import ActivityKit
import SunKit
import CoreLocation



class LiveActivityManager  {
    
    static let shared = LiveActivityManager()
    var sun: Sun
    var activity: Activity<SunsetWidgetAttributes>?
    
    init() {
        let defaultLocation = CLLocation(latitude: 37.331676, longitude: -122.030189)
        sun = Sun(location: LocationManager.shared.userLocation ?? defaultLocation, timeZone: TimeZone.current)
        sun.setDate(.now)
    }
    
    func addActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("\(ActivityAuthorizationError.self)")
            return
        }
        guard Activity<SunsetWidgetAttributes>.activities.isEmpty else {
            print("Cannot run multiple istance of the same activity!")
            return
        }
        let attributes = SunsetWidgetAttributes(sunsetTime: sun.sunset)
        let state = SunsetWidgetAttributes.ContentState()
        let activityContent = ActivityContent(state: state, staleDate: Calendar.current.date(byAdding: .hour, value: 12, to: Date())!)
        do {
            activity = try Activity<SunsetWidgetAttributes>.request(attributes: attributes, content: activityContent, pushType: nil)
        } catch(let error) {
            print("Error in creating live activity:  \(error.localizedDescription)")
        }
        print("Activitiy Added Successfully: \(String(describing: activity?.id))")
    }
    
    func stopActivity() {
        let finalStatus = SunsetWidgetAttributes.ContentState()
        let finalContent = ActivityContent(state: finalStatus, staleDate: nil)
        Task {
            for activity in Activity<SunsetWidgetAttributes>.activities {
                await activity.end(finalContent, dismissalPolicy: .immediate)
                print("Ending Live Activity: \(activity.id)")
            }
        }
    }
    
}
