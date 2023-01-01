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
    var labels: [String]
    var speed: Double
    var topLabel: String {
        return labels[0]
    }
}

struct Queue<T> {
    private var elements: [T] = []

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
    
    
    func handleDetection(observation: VNRecognizedObjectObservation, bounds: CGRect){
    
        let speed: Double = 50//LocationViewModel().currentSpeed
        let now = Date()
        let instant = DetectorInstant(
            dateTime: now,
            labels: [
                observation.labels[0].identifier,
                observation.labels[1].identifier,
                observation.labels[2].identifier,
            ],
            speed: speed
        )
        detectionsInstant.add(instant)
        
        
        /**
         The following piece of code serves to smooth out the results of detecting a stop sign
         By looking at the top 3 possible labels, and watching the majority over the last 10 detections, ensures more reliablity on the detection
         This will prevent situations, where the model might detect a stop sign where there is none, or miss a stop sign when it should be detected
         This errors might occor in one or two frames, so by looking at a larger sample, this effect should be mitigated
         */
        var i = 0
        detectionsInstant.newestX(lenght: 10).forEach { instant in
            if(instant.labels.contains("stop sign")){
                i += 1
            }
        }
        let stopSignedDetected = i > 5
        
        
        
        if stopSignedDetected == true {
            stopSignEnteredFrame = true
            importantTimestamps["stop_sign_enter_frame"] = Date()
        }
        if stopSignedDetected == false && stopSignEnteredFrame == true{
            stopSignEnteredFrame = false
            stopSignExitedFrame = true
            importantTimestamps["stop_sign_exit_frame"] = Date()
        }
        
        if(stopSignEnteredFrame == false && stopSignExitedFrame == false){
            //print("No stop sign")
        }
        
        //Stop sign currently in frame
        if(stopSignEnteredFrame == true && stopSignExitedFrame == false){
            //print("Stop sign in Frame")
        }
        
        //Stop sign just exited
        if(stopSignEnteredFrame == false && stopSignExitedFrame == true){
            //print("Stop Sign just exited frame")
            checkStopInfraction()
        }
        
        
        
        if Date().timeIntervalSince(importantTimestamps["stop_sign_exit_frame"] ?? Date()) > 15 {
            stopSignExitedFrame = false
            importantTimestamps["stop_sign_exit_frame"] = nil
        }
        
        //The instant recording list can be cleaned up after 10 seconds
        let timeSinceLastIntervalRecorded = Date().timeIntervalSince(detectionsInstant.oldest!.dateTime)
        if timeSinceLastIntervalRecorded > 10 {
            detectionsInstant.remove()
        }
    }
    
    func checkStopInfraction(){
        //Get all instants after stop left the frame
        let instantsAfterStop = detectionsInstant.get.filter { element in
            return importantTimestamps["stop_sign_exit_frame"] ?? Date() < element.dateTime
        }
        //Check if at any points since then the veichle was stoped
        let wasSpeedZero = instantsAfterStop.contains{ element in
            return element.speed < 1
        }
        
        if wasSpeedZero {
            importantTimestamps["possible_stop_infraction"] = nil
            stopSignExitedFrame = false
            stopSignEnteredFrame = false
        }
        
        //If its first time detecting possible infraction, register timestamp, else check if 10 seconds have passed
        if importantTimestamps["possible_stop_infraction"] == nil{
            importantTimestamps["possible_stop_infraction"] = Date()
        }else {
            let timeSincePossibleInfraction = Date().timeIntervalSince(importantTimestamps["possible_stop_infraction"]!)
            //If 10 seconds have passed and there still was no stop a.k.a. wasSpeedZero = true, then its an infraction
            if timeSincePossibleInfraction > 3 {createInfraction()}
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

