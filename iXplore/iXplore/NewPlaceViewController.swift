//
//  NewPlaceViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/14/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit
import MapKit

class NewPlaceViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var latitudeField: UITextField!
    @IBOutlet weak var longitudeField: UITextField!
    @IBOutlet weak var descriptionField: UITextField!
    @IBOutlet weak var currentLocationSwitch: UISwitch!
    @IBOutlet weak var image: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(backAction))

        self.navigationBar.topItem?.leftBarButtonItem = backButton
        
        self.image.image = UIImage(named: "defaultImage.png")
    }
    
    func backAction(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func currentLocationSwitchTapped(sender: UISwitch) {
        
        if !currentLocationSwitch.on {
            latitudeField.text = ""
            longitudeField.text = ""
        }
        
        else {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let locationManager = appDelegate.locationManager
            let lat = locationManager.location?.coordinate.latitude
            let long = locationManager.location?.coordinate.longitude
            
            if (lat == nil || long == nil) {
                let alert = UIAlertController(title: "Woops!", message: "You have not enabled location services for this app! Do so in Settings.", preferredStyle: .Alert)
                
                let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
                })
                
                alert.addAction(okAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else {
                latitudeField.text = "\(lat!)"
                longitudeField.text = "\(long!)"
            }
        }
    }
    
    @IBAction func uploadImageTapped(sender: UIButton) {
        imagePicker.delegate = self

        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.contentMode = .ScaleAspectFit
            image.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(sender: UIButton) {

        if ((titleField.text != "") && (latitudeField.text != "") && (longitudeField.text != "")) {
        
            let alert = UIAlertController(title: "Add Place", message: "Add '\(titleField.text!)' to Your Places?", preferredStyle: .ActionSheet)
            
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
                // go back to the main view when it's finished adding the place and it's set to okay
                let lat: CLLocationDegrees = Double(self.latitudeField.text!)!
                let long: CLLocationDegrees = Double(self.longitudeField.text!)!
                let coordinate = CLLocationCoordinate2D(latitude: lat,longitude: long)
                let photo = self.image.image
                
                let place:Place = Place(coordinate: coordinate, latitude: Double(self.latitudeField.text!)!, longitude: Double(self.longitudeField.text!)!, title: self.titleField.text, descriptor: self.descriptionField.text, date: NSDate(), image: photo, favorite: false)
                
                PlacesController.sharedInstance.addPlace(place)
                self.dismissViewControllerAnimated(true, completion: nil)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
        else {
            let alert = UIAlertController(title: "Woops!", message: "Please make sure the title, latitude, and longitude fields are filled.", preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
            })
            
            alert.addAction(okAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
