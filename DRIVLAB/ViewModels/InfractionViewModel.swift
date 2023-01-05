//
//  InfractionViewModel.swift
//  DRIVLAB
//
//  Created by David Batista on 04/01/2023.
//

import Foundation
import CoreLocation
import FirebaseFirestore

class InfractionViewModel: ObservableObject{
    @Published var loaded: Bool = false
    
    @Published var infractions = [Infraction]()
    
    private var db = Firestore.firestore()
    
    func createInfraction(infraction: Infraction){
        db.collection("infractions").addDocument(data: [
            "id": infraction.id,
            "driveId": infraction.driveId,
            "date": Date.getDate(date: infraction.date),
            "latitude": infraction.coordinates.latitude,
            "longitude": infraction.coordinates.longitude,
            "type": infraction.type,
            "value": infraction.value ?? ""
        ])

    }
    
    func fetchData(){
        db.collection("infractions").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.infractions = querySnapshot!.documents.map{ queryDocumentSnapshot -> Infraction in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let driveId = data["driveId"] as? String ?? ""
                    let date = Date.getDate(str: data["date"] as? String ?? "")
                    let latitude = data["latitude"] as? Double ?? 0.0
                    let longitude = data["longitude"] as? Double ?? 0.0
                    let type = data["type"] as? String ?? ""
                    return Infraction(
                        id: id,
                        driveId: driveId,
                        date: date,
                        coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        type: type
                    )
                    
                }
                self.loaded = true
            }
        }
    }
    
    func fetchData(driveId: String, orderBy: String = "date") {
        db.collection("infractions")
            .order(by: orderBy)
            .whereField("driveId", isEqualTo: driveId)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else if querySnapshot!.documents.count == 0 { ///Handle no infractions maybe??
                print("No infractions found!")
            } else {
                self.infractions = querySnapshot!.documents.map{ queryDocumentSnapshot -> Infraction in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let driveId = data["driveId"] as? String ?? ""
                    let date = Date.getDate(str: data["date"] as? String ?? "")
                    let latitude = data["latitude"] as? Double ?? 0.0
                    let longitude = data["longitude"] as? Double ?? 0.0
                    let type = data["type"] as? String ?? ""
                    return Infraction(
                        id: id,
                        driveId: driveId,
                        date: date,
                        coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                        type: type
                    )
                }
                self.loaded = true
            }
        }
    }
}

