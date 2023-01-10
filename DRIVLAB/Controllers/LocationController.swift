//
//  ViewController.swift
//  DRIVLAB
//
//  Created by David Batista on 18/11/2022.
//

import Foundation
import CoreLocation
import Combine
import MapKit


class LocationViewModel: NSObject, ObservableObject {
    //@Published var userLatitude: Double = 0
    //@Published var userLongitude: Double = 0
    @Published var currentSpeed: Double = 0
    @Published var unitString: String = "Km/h"
    
    @Published var topSpeed: Double = 0.0
    @Published var averageSpeed: Double = 0.0
    @Published var distance: Double = 0.0
    
    private var previousLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    private var speedCheckCount: Double = 0.0
    private var timer: DispatchSourceTimer?
    
    private var isOverSpeedLimit = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = false
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
        
        self.currentSpeed = speed * 3.6
    }
    
    func getCoordinates() -> CLLocationCoordinate2D {
        return locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
    func startLocationHandler(){
        speedCheckCount = 0
        let interval = Int(UserDefaults.standard.double(forKey: "locationUpdateInterval") * 1000)
        let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.schedule(deadline: .now(), repeating: .microseconds(interval))
        timer!.setEventHandler { [self] in
            // do whatever stuff you want on the background queue here here

            previousLocation = getCoordinates()
            DispatchQueue.main.async { [self] in
                infractionCheck()
                checkSpeed()
                updateDistance()
            }
        }
        timer!.resume()
    }
    
    func stopLocationHandler(){
        timer?.cancel()
        timer = nil
    }
    
    private func checkSpeed(){
        //Average Speed
        computeRollingAverageSpeed()
        //Top Speed
        if currentSpeed > topSpeed{
            topSpeed = currentSpeed
        }
    }
    
    private func updateDistance(){
        let currentLocation = getCoordinates()
        let instantDistance = previousLocation.distanceKm(to: currentLocation)
        distance = distance + instantDistance
        previousLocation = currentLocation
    }
    
    private func computeRollingAverageSpeed(){
        self.averageSpeed = (averageSpeed*(speedCheckCount/(speedCheckCount+1))) + (currentSpeed/(speedCheckCount+1));
        self.speedCheckCount += 1
    }
    
    
    /**
            Right now infractions are very strict, in the future this should be adjusted for a more friendly approach,
            At the moment, going over 120, user gets an infraction, going back to to 120 and then back over, will result in two distinct infractions, even if they were commited in the same time frame
            GPS might have slight fluctuations, and going from 120 to 121 to 120 and 121, can happen in just 4 seconds, and it will count as 2 infractions, since everytime it goes over, its one.
            Possible solutions might be, include a buffer for speed limit, like 10% or something, so he can go until 132,
            Might also be intersting to implement some type of cool down timer, since a user that goes over 120 for a few seconds, and one that stays at 160 for hours and hours, if he never comes back from that speed, will only count as one infraction, since it only went over the speed limit once, he just stayed that way for the following hours, so something that will create a new infraction every 5 minutes lets say, if he still hasnt stoped the previous infraction.
     */
    private func infractionCheck(){
        let speedLimit = Constants.speedLimit ///TODO: In theory, this value should be dynamic based on the road the user is in. From my reasearch this is not possible with the MapKit API, and would require a external API, for exemple, Google provides one:  https://developers.google.com/maps/documentation/roads/speed-limits - But there are concerns on how to get the data, since it will require either a path, or placeID, placeID would require additional requests to find out, and path would require saving more info from the route, and then using something to correct that path, since the coordinates might not exactly match, google provides a snapToRoads API that would allow this.
        if currentSpeed > speedLimit {
            if isOverSpeedLimit == false { /// User just went over the speed limit and an infraction must be created
                InfractionViewModel().createInfraction(infraction: Infraction(
                    driveId: UserDefaults.standard.string(forKey: "currentDriveId")!,
                    date: Date(),
                    coordinates: getCoordinates(),
                    type: "speed limit",
                    value: "\(currentSpeed)"
                ))
                isOverSpeedLimit = true
                return
            }
            /// User already went above the speed limit previously and infraction has been delt with
            
        }else {
            if isOverSpeedLimit == true { /// He just came down from over speed limit
                isOverSpeedLimit = false
                return
            }
            /// User never went above speed limit
        }
        
    }
    
}

extension CLLocationCoordinate2D {

    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        return MKMapPoint(self).distance(to: MKMapPoint(to))
    }
    
    func distanceKm(to: CLLocationCoordinate2D) -> CLLocationDistance {
        return MKMapPoint(self).distance(to: MKMapPoint(to)) / 1000.0
    }

}
