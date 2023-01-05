//
//  UserViewModel.swift
//  DRIVLAB
//
//  Created by David Batista on 04/01/2023.
//

import Foundation
import FirebaseFirestore

class UsersViewModel: ObservableObject{
    
    @Published var loaded: Bool = false
    
    @Published var user: User
    @Published var users = [User]()
    
    private var db = Firestore.firestore()
    
    init() {
        self.user = User.defaultUser()
        self.fetchLoggedUser()
    }
    
    func addData(user: User){
        db.collection("users").addDocument(data: [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "password": user.password,
            "photo_url": user.photo_url,
            "user_xp": user.user_xp,
            "distance_driven": user.distance_driven,
            "total_infractions": user.total_infractions,
            "perfect_drives": user.perfect_drives,
            "current_streak": user.current_streak,
            "longest_streak": user.longest_streak,
        ])

    }
    
    func fetchAllUsers(orderBy: String = "user_xp"){
        let userId = User.loggedUserId
        db.collection("users")
            .order(by: orderBy, descending: true)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.users = querySnapshot!.documents.map{ queryDocumentSnapshot -> User in
                    let data = queryDocumentSnapshot.data()
                    return User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        password: data["password"] as? String ?? "",
                        photo_url: data["photo_url"] as? String ?? "",
                        user_xp: data["user_xp"] as? Int ?? 0,
                        distance_driven: data["distance_driven"] as? Double ?? 0.0,
                        total_infractions: data["total_infractions"] as? Int ?? 0,
                        perfect_drives: data["perfect_drives"] as? Int ?? 0,
                        current_streak: data["current_streak"] as? Int ?? 0,
                        longest_streak: data["longest_streak"] as? Int ?? 0
                    )
                }
                self.user = users.first(where: { $0.id == userId }) ?? User.defaultUser()
                self.loaded = true
            }
        }
    }
    
    func fetchLoggedUser(){
        let userId = User.loggedUserId
        db.collection("users")
            .whereField("id", isEqualTo: userId)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else if querySnapshot!.documents.count != 1 {
                print("There should only be one user with id \(userId), but found multiple, or none: \(querySnapshot!.documents.count)")
            } else {
                self.user = querySnapshot!.documents.map{ queryDocumentSnapshot -> User in
                    let data = queryDocumentSnapshot.data()
                    return User(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        password: data["password"] as? String ?? "",
                        photo_url: data["photo_url"] as? String ?? "",
                        user_xp: data["user_xp"] as? Int ?? 0,
                        distance_driven: data["distance_driven"] as? Double ?? 0.0,
                        total_infractions: data["total_infractions"] as? Int ?? 0,
                        perfect_drives: data["perfect_drives"] as? Int ?? 0,
                        current_streak: data["current_streak"] as? Int ?? 0,
                        longest_streak: data["longest_streak"] as? Int ?? 0
                    )
                }.first!
                self.loaded = true
            }
        }
    }
    
    func updateProfile(updatedUser: User){
        //User just leveled up!
        if updatedUser.level > user.level {
            PopUpView.showLevelUpScreen(level: updatedUser.level)
        }
        
        user = updatedUser
        
        db.collection("users")
            .whereField("id", isEqualTo: updatedUser.id)
            .getDocuments(){ (querySnapshot, err) in
                if let err = err {
                    print("Error Getting documents: \(err)")
                    return
                } else if querySnapshot!.documents.count != 1 {
                    print("There should only be one drive with this id, but found multiple, or none")
                } else {
                    let document = querySnapshot!.documents.first
                    document!.reference.updateData([
                        "user_xp": updatedUser.user_xp,
                        "distance_driven": updatedUser.distance_driven,
                        "total_infractions": updatedUser.total_infractions,
                        "perfect_drives": updatedUser.perfect_drives,
                        "current_streak": updatedUser.current_streak,
                        "longest_streak": updatedUser.longest_streak,
                    ])
                }
            }
    }
    
}

