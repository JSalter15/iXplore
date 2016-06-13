//
//  LandingScreenViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/13/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit

class LandingScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Welcome!"
        navigationController?.navigationBarHidden = false
    }

    @IBAction func loginTapped(sender: UIButton) {
        let lvc = LoginViewController()
        navigationController?.pushViewController(lvc, animated: true)
    }
    
    
    @IBAction func registerTapped(sender: UIButton) {
        let rvc = RegisterViewController()
        navigationController?.pushViewController(rvc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 }
