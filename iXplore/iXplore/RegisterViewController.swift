//
//  RegisterViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/13/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailField: EmailValidatedTextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Register"
        emailField.delegate = self
        passwordField.delegate = self
    }

    @IBAction func registerTapped(sender: UIButton) {
        let email:String? = emailField.text
        let password:String? = passwordField.text
        
        if emailField.validate() {
            let (user, message) = UserController.sharedInstance.registerUser(email!, password: password!)
            
            if (user != nil) {
                print("User registered view registration view")
                
                let success = UIAlertController(title: "Congrats!", message: "You have successfully registered.", preferredStyle: UIAlertControllerStyle.Alert)
                let okButton = UIAlertAction(title: "Okay", style: .Default, handler: nil)
                success.addAction(okButton)
                self.presentViewController(success, animated: true, completion: nil)
                
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
