//
//  SunsetWidgetLiveActivity.swift
//  SunsetWidget
//
//  Created by Pietro Ciuci on 31/05/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SunsetWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
    }
    
    // Fixed non-changing properties about your activity go here!
    var sunsetTime: Date
    var progressInterval: ClosedRange<Date> {
        let start = Date()
        let end = start.addingTimeInterval(sunsetTime.timeIntervalSinceNow)
        return start...end
    }
}

struct SunsetWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SunsetWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(Color.clear)
                HStack(spacing: 10) {
                    //Text("Sunset")
                    Image(systemName: "sunset.fill")
                        .font(.system(size: 35))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    ProgressView(timerInterval: context.attributes.progressInterval, countsDown: true) {
                        Text("Time left")
                            .font(.caption)
                    }
                    .tint(.white)
                    .foregroundColor(.white)
                    .padding(.vertical, -15)
                    Text(context.attributes.sunsetTime, style: .time)
                        .font(.system(size: 20, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
            }
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "sunset.fill")
                        .foregroundColor(Color.white)
                        .font(.title)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.attributes.sunsetTime, style: .time)
                        .font(.system(size: 18, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .padding(.vertical, 10)
                }
                DynamicIslandExpandedRegion(.center) {
                    // Nothing here
                }
                DynamicIslandExpandedRegion(.bottom) {
                    ProgressView(timerInterval: context.attributes.progressInterval, countsDown: true) {
                        // Label needed?
                    }
                    .tint(.white)
                    .foregroundColor(.white)
                    .scaleEffect(x: 1.5, y: 1.5, anchor: .center)
                    .padding(.horizontal, 57)
                    .padding(.vertical, 5)
                }
            } compactLeading: {
                Image(systemName: "sunset.fill")
                    .foregroundColor(Color.white)
            } compactTrailing: {
                Text(context.attributes.sunsetTime, style: .time)
                    .font(.system(.body, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
            } minimal: {
                Image(systemName: "sunset.fill")
                    .foregroundColor(Color.white)
                    .padding()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.white)
        }
    }
}

struct SunsetWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = SunsetWidgetAttributes(sunsetTime: .now)
    static let contentState = SunsetWidgetAttributes.ContentState()
    
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
