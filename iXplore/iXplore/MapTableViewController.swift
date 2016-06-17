//
//  MapTableViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/8/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var placeList:[Place]?
    
    var locationManager:CLLocationManager?
    var locationAllowed:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Get places array
        self.placeList = PlacesController.sharedInstance.getPlaces()
        
        // Set up navigation bar
        self.title = "Your Places"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(addTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(logoutTapped))
        
        // Ask to use current location
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        locationManager = appDelegate.locationManager
        locationManager?.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        
        // Set up map and table
        setupMapView()
        setupTableView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.placeList = PlacesController.sharedInstance.getPlaces()
        setupMapView()
        tableView.reloadData()
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status {
        case .NotDetermined:
            locationManager!.requestAlwaysAuthorization()
            break
        case .AuthorizedWhenInUse:
            locationManager!.startUpdatingLocation()
            locationAllowed = true
            break
        case .AuthorizedAlways:
            locationManager!.startUpdatingLocation()
            locationAllowed = true
            break
        case .Restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .Denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        }
    }
    
    func setupMapView() {
        mapView.mapType = .HybridFlyover
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.addAnnotations(placeList!)
    }
    
    func setupTableView () {
        self.tableView.registerClass(SpotTableViewCell.self, forCellReuseIdentifier: "spotTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func addTapped() {
        let newPlaceView = NewPlaceViewController()
        presentViewController(newPlaceView, animated: true, completion: nil)
    }
    
    func logoutTapped(sender:UIButton) {
        UserController.sharedInstance.setLoggedInUser(nil)
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navigateToOnboardingView()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (placeList?.count)!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let place = placeList![indexPath.row]
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center:place.coordinate, span:span)
        mapView.setRegion(region, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        mapView.selectAnnotation(place, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let place = placeList![indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("spotTableViewCell") as! SpotTableViewCell
        
        // Set cell title and image
        cell.titleLabel.text = place.title
        cell.cellImage.image = place.image
        
        // Set cell date
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm a"
        let convertedDate:String = dateFormatter.stringFromDate(place.date)
        cell.dateLabel.text = convertedDate
        
        if place.favorite {
            cell.star.hidden = false
        }
        else {
            cell.star.hidden = true
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        // Delete action
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            print("Delete tapped")
            
            let alert = UIAlertController(title: "Place favorited!", message: "Confirm?", preferredStyle: .ActionSheet)
            
            let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
                self.mapView.removeAnnotation(self.placeList![indexPath.row])
                PlacesController.sharedInstance.removePlace(self.placeList![indexPath.row])
                self.placeList?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        delete.backgroundColor = UIColor.redColor()
        
        // Favorite or unfavorite action
        var favorite = UITableViewRowAction()
        if !placeList![indexPath.row].favorite {
            favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
                print("Favorite tapped")
                
                let alert = UIAlertController(title: "Place favorited!", message: "Confirm?", preferredStyle: .ActionSheet)
                
                let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
                    PlacesController.sharedInstance.changeFavoritePlace(self.placeList![indexPath.row], favorite: true)
                    self.placeList![indexPath.row].favorite = true
                    self.updateAnnotation(self.placeList![indexPath.row])
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                })
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            }
        }
        else if placeList![indexPath.row].favorite {
            favorite = UITableViewRowAction(style: .Normal, title: "Unfavorite") { action, index in
                print("Unfavorite tapped")
                
                let alert = UIAlertController(title: "Place unfavorited.", message: "Are you sure?", preferredStyle: .ActionSheet)
                
                let okAction = UIAlertAction(title: "Okay", style: .Default, handler: {(okAction) -> Void in
                    PlacesController.sharedInstance.changeFavoritePlace(self.placeList![indexPath.row], favorite: false)
                    self.placeList![indexPath.row].favorite = false
                    self.updateAnnotation(self.placeList![indexPath.row])
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Right)
                })
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {action in
                })
                
                alert.addAction(okAction)
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        return [favorite, delete]
    }
    
    func updateAnnotation(annotation:MKAnnotation) {
        mapView.removeAnnotation(annotation)
        mapView.addAnnotation(annotation)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if let place:Place = annotation as? Place {
            let anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            
            var pinImage:String
            if place.favorite {
                pinImage = "yellowPin.png"
            }
            else {
                pinImage = "redPin.png"
            }
            
            let pin = UIImage(named: pinImage)
            let size = CGSize(width: 21.91919191, height: 35)
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            pin!.drawInRect(CGRectMake(0, 0, size.width, size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            anView.image = resizedImage
            anView.canShowCallout = true
            
            return anView
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
