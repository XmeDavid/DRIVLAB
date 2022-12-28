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
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var password: String
    var photo_url: String
    var user_xp: Int = 0
    
    //To be used by the application to create a brand new instance, id is automatic and password is hashed
    init(name: String, email: String, password: String, photo_url: String) {
        self.name = name
        self.email = email
        self.photo_url = photo_url
        self.password = User.hashPassword(password: password)
    }
    
    //To be used by when constructing from data from firebase, since the ID is already created and password doesnt need hashing
    init(id: String, name: String, email: String, password: String, photo_url: String, user_xp: Int){
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.photo_url = photo_url
        self.user_xp = user_xp
    }
    
    static func hashPassword(password: String) -> String{
        return SHA256.hash(data: Data(password.utf8)).description
    }
}

class UsersViewModel: ObservableObject{
    @Published var user: User
    @Published var users = [User]()
    
    private var db = Firestore.firestore()
    
    init() {
        self.user = User(id: "00001EXAMPLEID", name: "Example", email: "example@mail.com", password: "P@ssw0rd", photo_url: "", user_xp: 0)
    }
    
    func addData(user: User){
        db.collection("users").addDocument(data: [
            "id": user.id,
            "name": user.name,
            "email": user.email,
            "password": user.password,
            "photo_url": user.photo_url,
            "user_xp": user.user_xp
        ])

    }
    
    func fetchData(orderBy: String = "user_xp"){ //It works!
        db.collection("users")
            .order(by: orderBy, descending: true)
            .getDocuments() { [self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.users = querySnapshot!.documents.map{ queryDocumentSnapshot -> User in
                    let data = queryDocumentSnapshot.data()
                    let id = data["id"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let password = data["password"] as? String ?? ""
                    let photo_url = data["photo_url"] as? String ?? ""
                    let user_xp = data["user_xp"] as? Int ?? 0
                    return User(id: id, name: name, email: email, password: password, photo_url: photo_url, user_xp: user_xp)
                }
            }
        }
    }
}

