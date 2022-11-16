//
//  ActivityDetailsView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct Activity: Identifiable {
    var id: Int
    var name: String
    
}

struct ActivityDetailsView: View {
    var activity: Activity
    var body: some View {
        Text(activity.name)
    }
}

struct ActivityDetailsView_Previews: PreviewProvider {
    
    static let activityPreview = Activity(
            id: 0,
            name: "Test"
        )
    
    static var previews: some View {
        ActivityDetailsView(activity: activityPreview)
    }
}
