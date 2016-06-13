//
//  LoginViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/13/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Login"
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func loginTapped(sender: UIButton) {
        let email:String? = emailField.text
        let password:String? = passwordField.text
        
        if emailField.validate() {
            let (user, message) = UserController.sharedInstance.loginUser(email!, password: password!)
            
            if (user != nil) {
                print("User registered view registration view")

                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.navigateToMapTableView()
            }
            else if (message != nil) {
                let error = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let okButton = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                error.addAction(okButton)
                
                self.presentViewController(error, animated: true, completion: nil)
            }
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
