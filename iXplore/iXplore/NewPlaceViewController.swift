//
//  NewPlaceViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/14/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit
import MapKit

class NewPlaceViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backAction))

        self.navigationBar.topItem?.leftBarButtonItem = backButton
    }
    
    func backAction(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {
        let lat: CLLocationDegrees = Double(latitudeField.text!)!
        let long: CLLocationDegrees = Double(longitudeField.text!)!
        let coordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
        
        let place:Place = Place(coordinate: coordinate, latitude: Double(latitudeField.text!)!, longitude: Double(longitudeField.text!)!, title: titleField.text, descriptor: descriptionField.text, date: NSDate(), favorite: false)
        
        PlacesController.sharedInstance.addPlace(place)
        
        let alert = UIAlertController(title: "Success!", message: "'\(titleField.text!)' has been added to Your Places.", preferredStyle: .ActionSheet)
        let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
            // go back to the main view when it's finished adding the place and it's set to okay
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
