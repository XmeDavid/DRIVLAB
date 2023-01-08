//
//  CameraView.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import SwiftUI

struct CameraView: View {
    
    
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("showSpeed") var showSpeed = true
    @AppStorage("currentDriveId") var currentDriveId = ""
    @ObservedObject var locationViewModel = LocationViewModel()
    @ObservedObject var driveViewModel = DrivesViewModel()
    
    @State private var speedCheckCount: Double = 0
    
    var body: some View {
        
        
        if currentDriveId != "" {
            ZStack(alignment: .top){
                Text("Starting...")
                HostedDRIVLABController().ignoresSafeArea()
                VStack{
                    if self.showSpeed == true {
                        VStack{
                            HStack{
                                Text("\(Int(locationViewModel.currentSpeed))")
                                    .font(.system(size: 92.0))
                                    .fontWeight(.light)
                                Image(systemName: "kph.circle")
                                    .font(.system(size:64))
                                    
                            }
                            .padding()
                            HStack{
                                Text("Average Speed:")
                                Text("\(locationViewModel.averageSpeed, specifier: "%.1f")")
                                    .fontWeight(.bold)
                            }
                            .offset(y: -32)
                            HStack{
                                Text("Distance:")
                                Text("\(locationViewModel.distance, specifier: "%.1f") Km")
                                    .fontWeight(.bold)
                            }
                            .offset(y: -16)
                        }
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
                Image(colorScheme  == .dark ? "logo-white" : "logo-black")
                    .resizable()
                    .scaledToFit()
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
            }.padding()
        }
    }
    
    func startDrive(){
        locationViewModel.resumeUpdates()
        currentDriveId = UUID().uuidString
        
        driveViewModel.startDrive(driveId: currentDriveId)
        
        locationViewModel.startLocationHandler()
    }
    
    

    
    func endDrive(){
        driveViewModel.endDrive(
            topSpeed: locationViewModel.topSpeed,
            averageSpeed: locationViewModel.averageSpeed,
            distance: locationViewModel.distance
        )

        locationViewModel.stopUpdates()
        locationViewModel.stopLocationHandler()
        currentDriveId = ""
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
