//
//  Infraction.swift
//  DRIVLAB
//
//  Created by David Batista on 13/12/2022.
//

import Foundation
import CoreLocation
import FirebaseFirestore

struct Infraction: Identifiable{
    var id: String = UUID().uuidString
    var driveId: String
    var date: Date
    var coordinates: CLLocationCoordinate2D
    var type: String
    var asString: String{
        switch type{
        case "stop sign":
            return "Stop Sign from \(Date.asShort(date: date))"
        case "speed limit":
            return "Speed Limit from \(Date.asShort(date: date))"
        default:
            return "Unknown Infraction"
        }
    }
}


class InfractionViewModel: ObservableObject{
    @Published var infractions = [Infraction]()
    
    private var db = Firestore.firestore()
    
    func createInfraction(infraction: Infraction){
        db.collection("infractions").addDocument(data: [
            "id": infraction.id,
            "driveId": infraction.driveId,
            "endDate": Date.getDate(date: infraction.date),
            "latitude": infraction.coordinates.latitude,
            "longitude": infraction.coordinates.longitude,
            "type": infraction.type,
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
            }
        }
    }
    
    func fetchData(driveId: String, orderBy: String = "date"){
        infractions = [Infraction]()
        db.collection("infractions")
            .order(by: orderBy)
            .whereField("driveId", isEqualTo: driveId)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                if querySnapshot!.documents.count == 0 {
                    print("No items")
                }
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
            }
        }
        print(infractions)
    }
}
