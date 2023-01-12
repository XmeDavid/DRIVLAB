//
//  DriveViewModel.swift
//  DRIVLAB
//
//  Created by David Batista on 04/01/2023.
//

import Foundation
import FirebaseFirestore

class DrivesViewModel: ObservableObject{
    @Published var drives = [Drive]()
    @Published var currentDrive: Drive? = nil
    @Published var isEmpty:Bool = true
    
    private var db = Firestore.firestore()
    
    func startDrive(driveId: String){
        
        currentDrive = Drive(
            id: driveId,
            user_id: User.loggedUserId,
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
    func endDrive(topSpeed: Double, averageSpeed: Double, distance: Double){
        guard let currentDriveId = UserDefaults.standard.string(forKey: "currentDriveId") else {
            print("Error")
            return
        }
        guard let _ = currentDrive else {
            print("Trying to end drive that never started")
            return
        }
        let endDate = Date()
        let infractionModel = InfractionViewModel()
        infractionModel.fetchData(driveId: currentDriveId)
        let userModel = UsersViewModel()

        Task{
            while !userModel.loaded && !infractionModel.loaded{
                try await Task.sleep(nanoseconds: 50_000_000)
            }
            
            let driveInfractionsCount = infractionModel.infractions.count
            
            currentDrive!.distance = distance
            currentDrive!.topSpeed = topSpeed
            currentDrive!.averageSpeed = averageSpeed
            currentDrive!.infractionsMade = driveInfractionsCount
            currentDrive!.endDate = endDate
            
            currentDrive!.gainedXP = Drive.computeXP(drive: currentDrive!, infractions: infractionModel.infractions)
            
            PopUpView.showEndDriveScreen(drive: currentDrive!)
            
            //Update User
            var updatedUser = userModel.user
            
            if driveInfractionsCount  > 0{      //If no infractions means perfect drive, add that to the profile
                updatedUser.total_infractions += driveInfractionsCount
                updatedUser.current_streak = 0
            }else{                              //If there are infractions add that to the total of the profile
                updatedUser.perfect_drives += 1
            }
            
            updatedUser.distance_driven += distance
            
            
            updatedUser.user_xp += currentDrive!.gainedXP!
            
            userModel.updateProfile(updatedUser: updatedUser)
        
        
            //Register Drive in Firebase after everything is done
            db.collection("drives")
                .whereField("id", isEqualTo: currentDriveId)
                .getDocuments(){ [self] (querySnapshot, err) in
                    if let err = err {
                        print("Error Getting documents: \(err)")
                        return
                    } else if querySnapshot!.documents.count != 1 {
                        print("There should only be one drive with this id, but found multiple, or none")
                    } else {
                        let document = querySnapshot!.documents.first
                        document!.reference.updateData([
                            "endDate": Date.getDate(date: currentDrive!.endDate!),
                            "infractionsMade": currentDrive!.infractionsMade,
                            "averageSpeed": currentDrive!.averageSpeed,
                            "topSpeed": currentDrive!.topSpeed,
                            "distance": currentDrive!.distance
                        ])
                    }
                }
        }
    }
    
    
    ///TODO: Might be useless
    /*func updateDrive(driveId: String, topSpeed: Double? = nil){
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
    }*/
    
    func fetchData(orderBy: String = "startDate"){
        db.collection("drives")
            .whereField("user_id", isEqualTo: User.loggedUserId)
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
                self.isEmpty = self.drives.isEmpty
            }
        }
    }
}
