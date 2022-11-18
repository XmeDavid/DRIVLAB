//
//  Drive.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation
import FirebaseFirestore

struct Drive: Identifiable {
    var id: String = UUID().uuidString
    var date: Date
    var infractionsMade: Int
    var averageSpeed: Double
    var distance: Double
    
    func dateString() -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        return df.string(from: date)
    }
    
    func timeString() -> String{
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df.string(from: date)
    }
    
    func dateTime() -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm"
        return df.string(from: date)
    }
    
    static func getDate(str: String) -> Date{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.date(from: str) ?? Date()
    }
    
    static func getDate(date: Date) -> String{
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return df.string(from: date)
    }
}


class DrivesViewModel: ObservableObject{
    @Published var drives = [Drive]()
    
    private var db = Firestore.firestore()
    
    func addData(drive: Drive){
        db.collection("drives").addDocument(data: ["id": drive.id, "date": Drive.getDate(date: drive.date), "infractionsMade": drive.infractionsMade, "averageSpeed": drive.averageSpeed, "distance": drive.distance])

    }
    
    func fetchData(){
        db.collection("drives").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.drives = querySnapshot!.documents.map{ queryDocumentSnapshot -> Drive in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let date = Drive.getDate(str: data["date"] as? String ?? "")
                    let infractions = data["infractionsMade"] as? Int ?? 0
                    let speed = data["averageSpeed"] as? Double ?? 0.0
                    let distance = data["distance"] as? Double ?? 0.0
                    return Drive(
                        id: id,
                        date: date,
                        infractionsMade: infractions,
                        averageSpeed: speed,
                        distance: distance
                    )
                }
            }
        }
    }
}
