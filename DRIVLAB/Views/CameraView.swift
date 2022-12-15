//
//  CameraView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct CameraView: View {
    
    @AppStorage("showSpeed") var showSpeed = true
    @AppStorage("currentDriveId") var currentDriveId = ""
    @ObservedObject var locationViewModel = LocationViewModel()
    @ObservedObject var driveViewModel = DrivesViewModel()
    
    @State private var timer: DispatchSourceTimer?
    @State private var speedCheckCount: Double = 0
    
    var body: some View {
        if currentDriveId != "" {
            ZStack(alignment: .top){
                Text("Starting...")
                HostedCameraController().ignoresSafeArea()
                VStack{
                    if self.showSpeed == true {
                        Text("\(Int(locationViewModel.currentSpeed))")
                            .font(.system(size: 82.0))
                            .fontWeight(.regular)
                            .padding()
                        Text("\(driveViewModel.currentDrive?.averageSpeed ?? 0, specifier: "%.2f")")
                    }
                    Spacer()
                    Button(action: endDrive){
                        Text("End Drive")
                            .font(.system(size:32))
                            .foregroundColor(.white)
                            .frame(width: 128, height: 128)
                            .padding()
                            .background(Color.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 128)
                                    .stroke(Color.gray, lineWidth: 4)
                            )
                            .shadow(radius: 32)
                    }
                        .cornerRadius(128)
                        .shadow(radius: 32)
                        .padding()
                }
                
                
                // Button("New Drive",action: newDrive)
            }
        }else{
            VStack{
                Text("DRIVLAB")
                    .font(.system(size:72))
                    .padding()
                Spacer()
                Button(action: startDrive){
                    Text("Start Drive")
                        .font(.system(size:32))
                        .foregroundColor(.white)
                        .frame(width: 128, height: 128)
                        .padding()
                        .background(Color.green)
                        .overlay(
                            RoundedRectangle(cornerRadius: 128)
                                .stroke(Color.gray, lineWidth: 4)
                        )
                        .shadow(radius: 32)
                }
                    .cornerRadius(128)
                    .shadow(radius: 32)
                    .padding()
            }
        }
    }
    
    func startDrive(){
        currentDriveId = UUID().uuidString
        
        driveViewModel.currentDrive = Drive(
            id: currentDriveId,
            user_id: "1",
            startDate: Date()
        )
        
        driveViewModel.startDrive(
            drive: driveViewModel.currentDrive!
        )
        startTimer()
    }
    
    func checkTopSpeed(){
        if currentDriveId != "" {
            let currentSpeed = locationViewModel.currentSpeed
            
            let newAverageRatio:Double = speedCheckCount / (speedCheckCount + 1)
            let preAverage:Double  = driveViewModel.currentDrive!.averageSpeed * newAverageRatio
            let addToAverage:Double  = currentSpeed / (speedCheckCount + 1)
            let newAverage = preAverage + addToAverage
            speedCheckCount += 1
        
            driveViewModel.currentDrive!.averageSpeed = newAverage
            
            print(newAverage)
            
            if currentSpeed > driveViewModel.currentDrive!.topSpeed {
                driveViewModel.currentDrive!.topSpeed = currentSpeed
            }
        }
    }
    
    func startTimer() {
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .seconds(1))
        timer!.setEventHandler { [self] in
            // do whatever stuff you want on the background queue here here

            checkTopSpeed()

            DispatchQueue.main.async {
                // update your model objects and/or UI here
            }
        }
        timer!.resume()
    }

    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
    
    func endDrive(){
        stopTimer()
        driveViewModel.endDrive()
        currentDriveId = ""
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
