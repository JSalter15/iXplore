//
//  UserController.swift
//  iXplore
//
//  Created by Joe Salter on 6/13/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var email: String?
    var password: String?
    
    required init(email:String?, password:String?) {
        self.email = email
        self.password = password
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.email, forKey: "email")
        aCoder.encodeObject(self.password, forKey: "password")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let email = aDecoder.decodeObjectForKey("email") as? String
        let password = aDecoder.decodeObjectForKey("password") as? String
        
        self.init(email:email, password:password)
        
    }
}

class UserController {

    class var sharedInstance: UserController {
        struct Static {
            static var instance:UserController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = UserController()
        }
        return Static.instance!
    }
    
    var allUsers: [User] = []
    
    var noUser = User(email: "", password: "")

    func registerUser(email:String, password:String) -> (User?, String?) {
        
        getUsers()

        let user = User(email: email, password: password)

        if doesUserExist(user) {
            return (nil, "There is already a user registered with that email")
        }
        
        allUsers.append(user)
        
        PersistenceManager.saveNSArray(allUsers, fileName: "usersArray")
        
        setLoggedInUser(user)
        
        return(user, nil)
    }
    
    func loginUser(email:String, password:String) -> (User?, String?) {
        
        getUsers()
        
        let user = User(email: email, password: password)

        if doesUserExist(user) {
            return (user, nil)
        }
        
        setLoggedInUser(user)
        
        return (nil, "Incorrect username or password!")
    }
    
    func getUsers() {
        
        let emptyUsers:[User] = []
        
        if let users = PersistenceManager.loadNSArray("usersArray") as? [User] {
            allUsers = users
            return
        }
        
        allUsers = emptyUsers
    }
    
    func doesUserExist(user:User) -> Bool {
        
        getUsers()
        
        for everyUser in allUsers {
            if ((user.email == everyUser.email) && user.password == everyUser.password){
                return true
            }
        }
        
        return false
    }
    
    func setLoggedInUser(user:User?) {
        if user == nil {
            PersistenceManager.saveObject(noUser, fileName: "loggedInUser")
        }
        else {
            PersistenceManager.saveObject(user!, fileName: "loggedInUser")
        }
    }
    
    func getLoggedInUser() -> User? {
        if let user = PersistenceManager.loadObject("loggedInUser") as? User {
            if ((user.email == noUser.email) && (user.password == noUser.password)) {
                return nil
            }
            return user
        }
        
        return nil
    }
}



