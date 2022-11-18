//
//  ActivityView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI


struct RecentActivityView: View {
    
    
    @ObservedObject var drivesModel = DrivesViewModel()
    
    
    var body: some View {
        NavigationStack(){
            List(drivesModel.drives){ drive in
                NavigationLink("Activity from " + drive.dateString()){
                    DriveDetailsView(drive: drive)
                }
            }
            .onAppear(){
                self.drivesModel.fetchData()
            }
        }
    }
}

struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        RecentActivityView()
    }
}
