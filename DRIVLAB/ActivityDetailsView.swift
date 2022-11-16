//
//  ActivityDetailsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI



struct ActivityDetailsView: View {
    var activity: Drive
    var body: some View {
        VStack(alignment: .leading){
            Text("Report")
                .font(.title3)
            Text("Drive #" + String(activity.id))
                .font(.title)
            Text("from " + activity.getDate())
                .font(.title2)
            Divider()
            Text("Average Speed: " + String(activity.averageSpeed))
            Text("Infractions Made: " + String(activity.infractionsMade))
            Spacer()
        }.padding()
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    
    static let activityPreview = Drive(
            id: 0,
            date: Date(),
            infractionsMade: 2,
            averageSpeed: 64.23
        )
    
    static var previews: some View {
        ActivityDetailsView(activity: activityPreview)
    }
}
