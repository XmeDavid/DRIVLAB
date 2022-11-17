//
//  CameraView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct CameraView: View {
    
    private func newDrive(){
        DrivesViewModel().addData(drive: Drive(
            date: Date(),
            infractionsMade: Int(arc4random_uniform(20)),
            averageSpeed: drand48()*100
        ))
    }
    
    var body: some View {
        Button("New Drive",action: newDrive)
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
