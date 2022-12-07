//
//  CameraView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct CameraView: View {
    
    @ObservedObject var locationViewModel = LocationViewModel()
    
    private func newDrive(){
        DrivesViewModel().addData(drive: Drive(
            user_id: "1",
            date: Date(),
            infractionsMade: Int(arc4random_uniform(20)),
            averageSpeed: drand48()*150,
            distance: drand48()*200
        ))
    }
    
    var body: some View {
        
        ZStack(alignment: .top){
            HostedCameraController().ignoresSafeArea()
            Text("\(Int(locationViewModel.currentSpeed))")
                .font(.system(size: 82.0))
                .fontWeight(.regular)
                .padding()
           // Button("New Drive",action: newDrive)
        }
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
