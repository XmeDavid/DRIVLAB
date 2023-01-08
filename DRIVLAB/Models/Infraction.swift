//
//  Infraction.swift
//  DRIVLAB
//
//  Created by David Batista on 13/12/2022.
//

import Foundation
import CoreLocation
import SwiftUI

struct Infraction: Identifiable{
    var id: String = UUID().uuidString
    var driveId: String
    var date: Date
    var coordinates: CLLocationCoordinate2D
    var type: String
    var value: String?
    
    var asString: String{
        switch type{
        case "stop sign":
            return "Stop Sign Infraction at \(date.timeString)"
        case "speed limit":
            return "Speed Limit Infraction at \(date.timeString)"
        default:
            return "Unknown Infraction"
        }
    }
    
    var valueString: String{
        switch type{
        case "stop sign":
            return ""
        case "speed limit":
            return "\(value ?? "") Km/h"
        default:
            return "Unknown Infraction"
        }
    }
    
    var title: String{
        switch type{
        case "stop sign":
            return "Stop Sign Infraction"
        case "speed limit":
            return "Speed Limit Infraction"
        default:
            return "Unknown Infraction"
        }
    }
    
    var time: String{
        let df = DateFormatter()
        df.dateFormat = "HH:mm:ss"
        return df.string(from: date)
    }
    
    var image: Image{
        switch type{
        case "stop sign":
            return Image("stop-sign")
        case "speed limit":
            return Image(systemName: "speedometer")
        default:
            return Image(systemName: "photo")
        }
    }
    
    var xp_dif: Int {
        switch type{
        case "stop sign":
            return 100
        case "speed limit":
            return 50
        default:
            return 10
        }
    }
}


