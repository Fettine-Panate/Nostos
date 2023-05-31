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
                        .fill(Color.red)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("Sunset")
                            .font(.system(size: 24, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        ProgressView(timerInterval: context.attributes.progressInterval, countsDown: true) {
                            Text("Time left")
                                .font(.caption)
                        }
                        .tint(.white)
                        .foregroundColor(.white)
                        Text(context.attributes.sunsetTime, style: .time)
                            .font(.system(size: 20, design: .rounded))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    //                .padding(15)
                }
                
            } dynamicIsland: { context in
                DynamicIsland {
                    // Expanded UI goes here.  Compose the expanded UI through
                    // various regions, like leading/trailing/center/bottom
                    DynamicIslandExpandedRegion(.leading) {
                        // Something I guess...?
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        // Something I guess...?
                    }
                    DynamicIslandExpandedRegion(.bottom) {
                        ProgressView(timerInterval: context.attributes.progressInterval, countsDown: true) {
                            HStack {
                                Image(systemName: "sunset.fill")
                                    .foregroundColor(Color.red)
                                Spacer()
                                Text(context.attributes.sunsetTime, style: .time)
                                    .font(.system(size: 16, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        }
                        .tint(.white)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    }
                } compactLeading: {
                    Image(systemName: "sunset.fill")
                        .foregroundColor(Color.red)
                } compactTrailing: {
                    Text(context.attributes.sunsetTime, style: .time)
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                } minimal: {
                    Text("Min")
                }
                .widgetURL(URL(string: "http://www.apple.com"))
                .keylineTint(Color.red)
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
