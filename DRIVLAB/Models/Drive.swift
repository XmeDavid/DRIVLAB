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
    
    func getDate() -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}


class DrivesViewModel: ObservableObject{
    @Published var drives = [Drive]()
    
    private var db = Firestore.firestore()
    
    func addData(drive: Drive){
        db.collection("drives").addDocument(data: ["id": drive.id, "date": drive.date, "infractionsMade": drive.infractionsMade, "averageSpeed": drive.averageSpeed])

    }
    
    func fetchData(){
        db.collection("drives").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print(querySnapshot!.documents)
                self.drives = querySnapshot!.documents.map{ queryDocumentSnapshot -> Drive in
                    let data = queryDocumentSnapshot.data()
                    print(data)
                    let id = data["id"] as? String ?? ""
                    //let date = data["date"] as? String ?? ""
                    let infractions = data["infractionsMade"] as? Int ?? 0
                    let speed = data["averageSpeed"] as? Double ?? 0.0
                    return Drive(
                        id: id,
                        date: Date(),
                        infractionsMade: infractions,
                        averageSpeed: speed
                    )
                }
                print(self.drives)
            }
        }
    }
}
