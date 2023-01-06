//
//  User.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation
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
        var newLevelThreashold = Constants.firstLevelXP
        var level = 0
        while user_xp > newLevelThreashold{
            level = level + 1
            newLevelThreashold = Int(Double(newLevelThreashold) * Constants.levelDifficulty)
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

