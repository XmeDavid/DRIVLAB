//
//  Drive.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation

struct Drive: Identifiable {
    var id: String
    var user_id: String
    var startDate: Date
    var endDate: Date? = nil
    var infractionsMade: Int
    var averageSpeed: Double
    var topSpeed: Double
    var distance: Double
    
    var gainedXP: Int?
    
    init(id: String, user_id: String, startDate: Date) {
        self.id = id
        self.user_id = user_id
        self.startDate = startDate
        self.endDate = nil
        self.infractionsMade = 0
        self.averageSpeed = 0
        self.topSpeed = 0
        self.distance = 0
    }
    
    init(id: String, user_id: String, startDate: Date, endDate: Date? = nil, infractionsMade: Int, averageSpeed: Double, topSpeed: Double, distance: Double) {
        self.id = id
        self.user_id = user_id
        self.startDate = startDate
        self.endDate = endDate
        self.infractionsMade = infractionsMade
        self.averageSpeed = averageSpeed
        self.topSpeed = topSpeed
        self.distance = distance
    }
    
}

extension Drive {
    static func computeXP(drive: Drive, infractions: [Infraction]) -> Int{
        //Get the Drive XP, with no infraction
        var xp = Double(Drive.computeXP(drive: drive))
        
        //Get XP Multiplier for multiple infractions.
        let infractionCountMultiplier = 1.0 + (Double(infractions.count - 1) * 0.1)
        
        //Remove XP for each Infraction
        for infraction in infractions {
            xp -= Double(infraction.xp_dif) * infractionCountMultiplier
        }
        
        return Int(xp)
    }
    
    static func computeXP(drive: Drive) -> Int{
        //Default XP for going on a drive
        var xp = 5.0
        
        //Give XP for distance
        xp += drive.distance * 12.0
        
        //Give XP for time driven
        let minutes = Double(drive.startDate.timeIntervalSince(drive.endDate!) / 60.0)
        xp += minutes * 2.0

        return Int(xp)
    }
}


extension Date{
    
    static func getDate(str: String) -> Date{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df.date(from: str) ?? Date()
    }
    
    static func getDate(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df.string(from: date)
    }
    
    var dateString: String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df.string(from: self)
    }
    
    var dateTimeString: String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy HH:mm"
        return df.string(from: self)
    }
    
    var timeString: String{
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        return df.string(from: self)
    }
}
