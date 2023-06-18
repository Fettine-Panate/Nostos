import Foundation
import SunKit

struct DayPhase {
    
    let sun: Sun
    let phases: [String: BackgroundColor]
    
    init(sun: Sun) {
        self.sun = sun
        var phases = [
            // Dawn
            dateFormatterHHMM.string(from: sun.astronomicalDawn) : BackgroundColor(color: "AstronmicalDawnColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.nauticalDawn) : BackgroundColor(color: "NauticalDawnColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.civilDawn) : BackgroundColor(color: "CivilDawnColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.morningGoldenHourStart) : BackgroundColor(color: "MorningGoldenHourStartColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.sunrise) : BackgroundColor(color: "SunriseColor", accentObjectOp: 0.25),
            // Day
            dateFormatterHHMM.string(from: sun.morningGoldenHourEnd) : BackgroundColor(color: "MorningGoldenHourEnd", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.solarNoon) : BackgroundColor(color: "SolarNoonColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.eveningGoldenHourStart) : BackgroundColor(color: "EveningGoldenHourStart", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.sunset) : BackgroundColor(color: "sunset", accentObjectOp: 0.25),
            // Dusk
            dateFormatterHHMM.string(from: sun.eveningGoldenHourEnd) : BackgroundColor(color: "EveningGoldenHourEndColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.civilDusk) : BackgroundColor(color: "CivilDuskColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.nauticalDusk) : BackgroundColor(color: "NauticalDuskColor", accentObjectOp: 0.25),
            dateFormatterHHMM.string(from: sun.astronomicalDusk) : BackgroundColor(color: "night", accentObjectOp: 0.25) // Night color after
        ]
        
        self.phases = phases
        
    }
    
    func closestFormattedDate(inputDateString: String, to dates: [String]) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        guard let inputDate = dateFormatter.date(from: inputDateString) else {
            return nil // Return nil if the input date cannot be converted correctly
        }
        
        var closestFormattedDateString: String?
        var closestTimeInterval: TimeInterval = Double.infinity
        
        for dateString in dates {
            if let date = dateFormatter.date(from: dateString) {
                let timeInterval = abs(date.timeIntervalSince(inputDate))
                if timeInterval < closestTimeInterval {
                    closestTimeInterval = timeInterval
                    closestFormattedDateString = dateString
                }
            }
        }
        
        return closestFormattedDateString
    }
    
    func getClosestColor(for currentTime: String) -> String {
        print("Calling because no color was found for \(currentTime)")
        var closestValue = ""
        if let closestDateString = closestFormattedDate(inputDateString: currentTime, to: Array(phases.keys)) {
            closestValue = phases[closestDateString]!.color
        } else {
            closestValue = "DefaultColor"
        }
        return closestValue
    }
    
}


struct BackgroundColor {
    let color: String
    var accentObjectOp : Double
}
