//
//  ViewController.swift
//  DRIVLAB
//
//  Created by David Batista on 18/11/2022.
//

import Foundation
import CoreLocation
import Combine


class LocationViewModel: NSObject, ObservableObject {
    //@Published var userLatitude: Double = 0
    //@Published var userLongitude: Double = 0
    @Published var currentSpeed: Double = 0
    @Published var unitString: String = "Km/h"
    
    private let locationManager = CLLocationManager()
    
    override init() {
      super.init()
      self.locationManager.delegate = self
      self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
      self.locationManager.requestWhenInUseAuthorization()
      self.locationManager.startUpdatingLocation()
      //self.locationManager.allowsBackgroundLocationUpdates = false
    }
    
    func stopUpdates() {
        
        self.locationManager.stopUpdatingLocation()
    }
    func resumeUpdates() {
        self.locationManager.startUpdatingLocation()
    }
    
}

extension LocationViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        var speed = location.speed
        
        if speed < 0 {
            speed = 0
        }
        
        currentSpeed = speed * 3.6
    }
}

