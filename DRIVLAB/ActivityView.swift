//
//  ActivityView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ActivityView: View {
    let activities: [Drive] = [
        Drive(
                id: 1,
                date: Date(),
                infractionsMade: 2,
                averageSpeed: 64.23
            )
    ]
    var body: some View {
        NavigationStack(){
            List(activities){ activity in
                NavigationLink("Activity #" + String(activity.id)){
                    ActivityDetailsView(activity: activity)
                }
            }
            .navigationTitle("Recent Activity")
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
