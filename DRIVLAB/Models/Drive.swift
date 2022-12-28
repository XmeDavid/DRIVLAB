//
//  Drive.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation
import FirebaseFirestore

struct Drive: Identifiable {
    var id: String
    var user_id: String
    var startDate: Date
    var endDate: Date? = nil
    var infractionsMade: Int
    var averageSpeed: Double
    var topSpeed: Double
    var distance: Double
    
    init(id: String, user_id: String, startDate: Date) {
        self.id = id
        self.user_id = user_id
        self.startDate = startDate
        self.endDate = nil
        self.infractionsMade = 0
        self.averageSpeed = 0
        self.topSpeed = 0
        self.distance = 0
    }
    
    init(id: String, user_id: String, startDate: Date, endDate: Date? = nil, infractionsMade: Int, averageSpeed: Double, topSpeed: Double, distance: Double) {
        self.id = id
        self.user_id = user_id
        self.startDate = startDate
        self.endDate = endDate
        self.infractionsMade = infractionsMade
        self.averageSpeed = averageSpeed
        self.topSpeed = topSpeed
        self.distance = distance
    }
    
}


class DrivesViewModel: ObservableObject{
    @Published var drives = [Drive]()
    @Published var currentDrive: Drive? = nil
    
    private var db = Firestore.firestore()
    
    func startDrive(driveId: String){
        
        let userID = "1" ///TODO: Implement User integration later, or maybe not, depends if auth is gonna be used.
        
        currentDrive = Drive(
            id: driveId,
            user_id: userID,
            startDate: Date()
        )
        
        db.collection("drives").addDocument(data: [
            "id": currentDrive!.id,
            "user_id": currentDrive!.user_id,
            "startDate": Date.getDate(date: currentDrive!.startDate),
            "endDate": "",
            "infractionsMade": currentDrive!.infractionsMade,
            "averageSpeed": currentDrive!.averageSpeed,
            "topSpeed": currentDrive!.topSpeed,
            "distance": currentDrive!.distance
        ])

    }
    
    //TODO
    func endDrive(topSpeed: Double, averageSpeed: Double){
        guard let currentDriveId = UserDefaults.standard.string(forKey: "currentDriveId") else {
            print("Error")
            return
        }
        let infractionModel = InfractionViewModel()
        infractionModel.fetchData(driveId: currentDriveId)
        
        db.collection("drives")
            .whereField("id", isEqualTo: currentDriveId)
            .getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error Getting documents: \(err)")
                    return
                } else if querySnapshot!.documents.count != 1 {
                    print("There should only be one drive with this id, but found multiple, or none")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        "endDate": Date.getDate(date: Date()),
                        "infractionsMade": infractionModel.infractions.count, ///TODO Update this by querying the list of infractions and counting
                        "averageSpeed": averageSpeed,
                        "topSpeed": topSpeed,
                        "distance": self.currentDrive?.distance ?? 0.0 ///TODO: Distances in general
                    ])
                }
            }
    }
    
    ///TODO: Might be useless
    func updateDrive(driveId: String, topSpeed: Double? = nil){
        if let topSpeed = topSpeed {
            db.collection("drives")
                .whereField("id", isEqualTo: driveId)
                .getDocuments(){ (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting documents: \(err)")
                        return
                    } else if querySnapshot!.documents.count != 1 {
                        print("There should only be one drive with this id, but found multiple, or none")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "topSpeed": topSpeed,
                        ])
                    }
                }
        }
    }
    
    func fetchData(orderBy: String = "startDate"){
        db.collection("drives")
            .order(by: orderBy, descending: true)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.drives = querySnapshot!.documents.map{ queryDocumentSnapshot -> Drive in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let user_id = data["user_id"] as? String ?? ""
                    let startDate = Date.getDate(str: data["startDate"] as? String ?? "")
                    let endDate = Date.getDate(str: data["endDate"] as? String ?? "")
                    let infractions = data["infractionsMade"] as? Int ?? 0
                    let averageSpeed = data["averageSpeed"] as? Double ?? 0.0
                    let topSpeed = data["topSpeed"] as? Double ?? 0.0
                    let distance = data["distance"] as? Double ?? 0.0
                    return Drive(
                        id: id,
                        user_id: user_id,
                        startDate: startDate,
                        endDate: endDate,
                        infractionsMade: infractions,
                        averageSpeed: averageSpeed,
                        topSpeed: topSpeed,
                        distance: distance
                    )
                }
            }
        }
    }
}


extension Date{
    
    static func getDate(str: String) -> Date{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df.date(from: str) ?? Date()
    }
    
    static func getDate(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df.string(from: date)
    }
    
    static func asShort(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df.string(from: date)
    }
    
}
