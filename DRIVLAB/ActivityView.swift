//
//  ActivityView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI


struct ActivityView: View {
    
    
    @ObservedObject var drivesModel = DrivesViewModel()
    
    
    var body: some View {
        NavigationStack(){
            List(drivesModel.drives){ drive in
                NavigationLink("Activity #" + String(drive.id)){
                    ActivityDetailsView(activity: drive)
                }
            }
            .navigationTitle("Recent Activity")
            .onAppear(){
                self.drivesModel.fetchData()
            }
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
