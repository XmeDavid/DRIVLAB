//
//  User.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation
import FirebaseFirestore
import CryptoKit

struct User: Hashable{
    
    ///Since we don't have an authentication system for the prototype, this id serves to know what user is logged in, in this case its a static value
    static let loggedUserId: String = "814A6FE3-6649-416C-B42C-65AA22B1F9D2"
    
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var password: String
    var photo_url: String
    
    var user_xp: Int = 0
    var distance_driven: Double = 0.0
    var total_infractions: Int = 0
    var perfect_drives: Int = 0
    var current_streak: Int = 0
    var longest_streak: Int = 0
    
    ///This is probably bad, the idea is, we need a level system where each level gets harder, we could have an array of threasholds where if he passes that he gets a new level, but that would mean there would be a finite number of levels, this solution allows for an unlimited number of levels, each one is 40% harder to get then the previous.
    var level: Int{
        var newLevelThreashold: Int = 100
        var level = 0
        while user_xp > newLevelThreashold{
            level = level + 1
            newLevelThreashold = Int(Double(newLevelThreashold) * 1.4)
        }
        return level
    }
    
    //To be used by the application to create a brand new instance, id is automatic and password is hashed
    init(name: String, email: String, password: String, photo_url: String) {
        self.name = name
        self.email = email
        self.photo_url = photo_url
        self.password = User.hashPassword(password: password)
    }
    
    //To be used by when constructing from data from firebase, since the ID is already created and password doesnt need hashing
    init(id: String, name: String, email: String, password: String, photo_url: String, user_xp: Int, distance_driven: Double, total_infractions: Int, perfect_drives: Int, current_streak: Int, longest_streak: Int){
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.photo_url = photo_url
        self.user_xp = user_xp
        self.distance_driven = distance_driven
        self.total_infractions = total_infractions
        self.perfect_drives = perfect_drives
        self.current_streak = current_streak
        self.longest_streak = longest_streak
    }
    
    static func hashPassword(password: String) -> String{
        return SHA256.hash(data: Data(password.utf8)).description
    }
    
    static func defaultUser() -> User{
        return User(id: "", name: "", email: "", password: "", photo_url: "", user_xp: 0, distance_driven: 0.0, total_infractions: 0, perfect_drives: 0, current_streak: 0, longest_streak: 0)
    }
}

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

