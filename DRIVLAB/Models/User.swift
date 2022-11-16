//
//  User.swift
//  DRIVLAB
//
//  Created by David Batista on 16/11/2022.
//

import Foundation

struct User{
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var password: String
    var photo_url: String
}

struct UserStats{
    
}
