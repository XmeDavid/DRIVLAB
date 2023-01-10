//
//  InfractionsController.swift
//  DRIVLAB
//
//  Created by David Batista on 12/12/2022.
//

import Foundation
import Vision
import CoreLocation


struct DetectorInstant{
    var dateTime: Date
    var label: String
}

struct Queue<T> {
    private var elements: [T] = []
    
    var isEmpty: Bool{
        return elements.isEmpty
    }
    
    var count: Int{
        return elements.count
    }

    mutating func add(_ value: T) {
        elements.append(value)
    }

    mutating func remove(){
        guard !elements.isEmpty else {
          return
        }
        elements.removeFirst()
    }
    
    func oldestX(lenght: Int) -> Array<T>.SubSequence {
        return elements.prefix(lenght)
    }
    
    func newestX(lenght: Int) -> Array<T>.SubSequence {
        return elements.suffix(lenght)
    }

    var oldest: T? {
        return elements.first
    }

    var newest: T? {
        return elements.last
    }

    var get: [T]{
        return elements
    }
}

extension DRIVLABController {
    
    
    func handleDetection(observation: VNRecognizedObjectObservation?){
    
        let now = Date()
        
        if observation == nil {
            stopSignEnteredFrame = false
            stopSignExitedFrame = true
            importantTimestamps["stop_sign_exit_frame"] = Date()
            let instant = DetectorInstant(
                dateTime: now,
                label: "background"
            )
            detectionsInstant.add(instant)
        }else {
            let instant = DetectorInstant(
                dateTime: now,
                label: observation!.labels[0].identifier
            )
            detectionsInstant.add(instant)
        }
        
        

        
        

        var i = 0
        detectionsInstant.newestX(lenght: 8).forEach { instant in
            if instant.label == "stop sign"{
                i += 1
            }
        }
        let stopSignedDetected = i > 4
        
        
        
        if stopSignedDetected == true && stopSignEnteredFrame == false && stopSignExitedFrame == false {
            stopSignEnteredFrame = true
            importantTimestamps["stop_sign_enter_frame"] = Date()
        }
        if stopSignedDetected == false && stopSignEnteredFrame == true && stopSignExitedFrame == false{
            stopSignEnteredFrame = false
            stopSignExitedFrame = true
            importantTimestamps["stop_sign_exit_frame"] = Date()
        }
     
        if(stopSignEnteredFrame == false && stopSignExitedFrame == true && isCheckingStopSign == false){
            isCheckingStopSign = true
            DispatchQueue(label: "pt.ipl.mei.cm.drivlab.check").async{
                self.checkStopInfraction()
            }
            stopSignExitedFrame = false
            
        }
        
        //Only keep 10 instants
        if detectionsInstant.count > 10 {
            detectionsInstant.remove()
        }
    }
    
    func checkStopInfraction() {
        guard let exitFrameTime = importantTimestamps["stop_sign_exit_frame"] else{
            return
        }
        Task{
            let locationViewModel = LocationViewModel()
            while Date().timeIntervalSince(exitFrameTime) < 3 {
                
                try await Task.sleep(nanoseconds: 200_000_000)
                let speed = locationViewModel.currentSpeed
                
                if speed < 2 {
                    isCheckingStopSign = false
                    return
                }
                
            }
            isCheckingStopSign = false
            createInfraction()
        }
        
    }
    
    /// Actually create an infraction, still not sure, maybe locally, but probably on firebase
    /// Create a document or something for the drive, and
    func createInfraction(){
        let infraction: Infraction = Infraction(
            driveId: UserDefaults.standard.string(forKey: "currentDriveId") ?? "Error - no Drive ID",
            date: Date(),
            coordinates: LocationViewModel().getCoordinates(),
            type: "stop sign"
        )
        InfractionViewModel().createInfraction(infraction: infraction)
        
        importantTimestamps["possible_stop_infraction"] = nil
        importantTimestamps["stop_sign_exit_frame"] = nil
        stopSignExitedFrame = false
        stopSignExitedFrame = false
    }
    
}

