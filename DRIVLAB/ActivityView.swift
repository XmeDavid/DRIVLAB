//
//  ActivityView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct ActivityView: View {
    let activities: [Activity] = [
        Activity(id: 1, name: "Hey1"),
        Activity(id: 2, name: "Hey2"),
        Activity(id: 3, name: "Hey3"),
        Activity(id: 4, name: "Hey4"),
    ]
    var body: some View {
        NavigationStack(){
            List(activities){ activity in
                NavigationLink(activity.name){
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
