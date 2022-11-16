//
//  Drive.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation

struct Drive: Identifiable {
    var id: Int
    var date: Date
    var infractionsMade: Int
    var averageSpeed: Double
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
