//
//  UserController.swift
//  iXplore
//
//  Created by Joe Salter on 6/13/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation

struct User {
    var email: String
    var password: String
    
    init(email:String, password:String)  {
        self.email = email
        self.password = password
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
    
    var logged_in_user: User?
    
    var users: [User] = []

    func registerUser(email:String, password:String) -> (User?, String?) {
        
        let user = User(email: email, password: password)

        if getLoggedInUser(user) {
            return (nil, "There is already a user registered with that email")
        }
        
        users.append(user)
        logged_in_user = user
        
        return(user, nil)
    }
    
    func loginUser(email:String, password:String) -> (User?, String?) {
        
        let user = User(email: email, password: password)

        if getLoggedInUser(user) {
            return (user, nil)
        }
        
        return (nil, "Incorrect username or password!")
    }
    
    func getLoggedInUser(user:User) -> Bool {
        for everyUser in users {
            if ((user.email == everyUser.email) && user.password == everyUser.password){
                return true
            }
        }
        return false
    }
}