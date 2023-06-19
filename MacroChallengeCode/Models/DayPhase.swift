import Foundation
import SunKit

struct DayPhase {
    
    let sun: Sun
    let phases: [Phase]
    
    init(sun: Sun) {
        self.sun = sun
        var phases = [
            Phase(name: "AstronmicalDawnColor", hour: sun.astronomicalDawn, color: BackgroundColorPalette(backgroundColor: "AstronmicalDawnColor", accentObjectOp: 0.25)),
            Phase(name: "NauticalDawnColor", hour: sun.nauticalDawn, color: BackgroundColorPalette(backgroundColor: "NauticalDawnColor", accentObjectOp: 0.25)),
            Phase(name: "CivilDawnColor", hour: sun.civilDawn, color: BackgroundColorPalette(backgroundColor: "CivilDawnColor", accentObjectOp: 0.25)),
            Phase(name: "MorningGoldenHourStartColor", hour: sun.morningGoldenHourStart, color: BackgroundColorPalette(backgroundColor: "MorningGoldenHourStartColor", accentObjectOp: 0.25)),
            Phase(name: "SunriseColor", hour:  sun.sunrise, color: BackgroundColorPalette(backgroundColor: "SunriseColor", accentObjectOp: 0.25)),
            Phase(name: "MorningGoldenHourEnd", hour: sun.morningGoldenHourEnd, color: BackgroundColorPalette(backgroundColor: "MorningGoldenHourEnd", accentObjectOp: 0.25)),
            Phase(name: "SolarNoonColor", hour: sun.solarNoon, color: BackgroundColorPalette(backgroundColor: "SolarNoonColor", accentObjectOp: 0.25)),
            Phase(name: "EveningGoldenHourStart", hour: sun.eveningGoldenHourStart, color: BackgroundColorPalette(backgroundColor: "EveningGoldenHourStart", accentObjectOp: 0.25)),
            Phase(name: "Sunset", hour: sun.sunset, color: BackgroundColorPalette(backgroundColor: "Sunset", accentObjectOp: 0.25)),
            Phase(name: "EveningGoldenHourEndColor", hour: sun.eveningGoldenHourEnd, color: BackgroundColorPalette(backgroundColor: "EveningGoldenHourEndColor", accentObjectOp: 0.25)),
            Phase(name: "CivilDuskColor", hour: sun.civilDusk, color: BackgroundColorPalette(backgroundColor: "CivilDuskColor", accentObjectOp: 0.25)),
            Phase(name: "NauticalDuskColor", hour: sun.nauticalDusk, color: BackgroundColorPalette(backgroundColor: "NauticalDuskColor", accentObjectOp: 0.25)),
            Phase(name: "Night", hour: sun.astronomicalDusk, color: BackgroundColorPalette(backgroundColor: "Night", accentObjectOp: 0.25))
        ]
        self.phases = phases
    }
    
    
    func getClosestPhase(currentTime : Date) -> Phase {
        if  currentTime < phases[0].hour {return (phases[12])}
        else if currentTime >= phases[0].hour && currentTime < phases[1].hour {return phases[0] }
        else if currentTime >= phases[1].hour && currentTime < phases[2].hour {return phases[1] }
        else if currentTime >= phases[2].hour && currentTime < phases[3].hour {return phases[2] }
        else if currentTime >= phases[3].hour && currentTime < phases[4].hour {return phases[3]  }
        else if currentTime >= phases[4].hour && currentTime < phases[5].hour {return phases[4]  }
        else if currentTime >= phases[5].hour && currentTime < phases[6].hour {return phases[5]  }
        else if currentTime >= phases[6].hour && currentTime < phases[7].hour {return phases[6]  }
        else if currentTime >= phases[7].hour && currentTime < phases[8].hour {return phases[7]  }
        else if currentTime >= phases[8].hour && currentTime < phases[9].hour {return phases[8]  }
        else if currentTime >= phases[9].hour && currentTime < phases[10].hour {return phases[9]  }
        else if currentTime >= phases[10].hour && currentTime < phases[11].hour {return phases[10]  }
        else if currentTime >= phases[11].hour && currentTime < phases[12].hour {return phases[11]  }
        else {return phases[12]  }
        
    }
    
}



struct BackgroundColorPalette {
    let backgroundColor: String
    var accentObjectOp : Double
}


struct Phase{
    var name :String
    var hour : Date
    var color : BackgroundColorPalette
}

