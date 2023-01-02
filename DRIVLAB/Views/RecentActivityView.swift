//
//  ActivityView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI


struct RecentActivityView: View {
    
    
    @ObservedObject var drivesModel: DrivesViewModel
    
    init() {
        self.drivesModel = DrivesViewModel()
        self.drivesModel.fetchData()
    }
    
    var body: some View {
        if drivesModel.isEmpty{
            VStack{
                Spacer()
                Text("No Drives registered yet!")
                    .foregroundColor(.gray)
                Text("Go for a drive with DRIVLAB to see data here...")
                    .foregroundColor(.gray)
                Spacer()
            }
        }else{
            NavigationStack(){
                List(drivesModel.drives){ drive in
                    NavigationLink("Activity from " + Date.getDate(date: drive.startDate)){
                        DriveDetailsView(drive: drive)
                    }
                }
            }
        }
    }
}

struct RecentActivityView_Previews: PreviewProvider {
    static var previews: some View {
        RecentActivityView()
    }
}
