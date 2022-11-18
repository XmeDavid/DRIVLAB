//
//  ActivityDetailsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct DriveDetailsView: View {
    var drive: Drive
    var body: some View {
        VStack(alignment: .leading){
            Text("Report from " + drive.dateString())
                .font(.title)
            Divider()
            Text(String(format: "Average Speed: %.2fKm/h", drive.averageSpeed))
            Text("Infractions Made: " + String(drive.infractionsMade))
            Text(String(format: "Distance Traveled: %.2fKm", drive.distance))
            Spacer()
        }.padding()
    }
}

struct DriveDetailsView_Previews: PreviewProvider {
    
    static let drivePreview = Drive(
            id: "0",
            date: Date(),
            infractionsMade: 0,
            averageSpeed: 0.0,
            distance: 0.0
        )
    
    static var previews: some View {
        DriveDetailsView(drive: drivePreview)
    }
}
