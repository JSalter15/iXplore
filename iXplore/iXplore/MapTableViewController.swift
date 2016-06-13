//
//  MapTableViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/8/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var placeList:[Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.placeList = Place.placeList()
        
        let button = UIButton(frame: CGRectMake(15, 20, 100, 25))
        button.backgroundColor = UIColor.blackColor()
        
        button.setTitle("Log Out", forState: .Normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(logoutTapped), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
        setupMapView()
        setupTableView()
    }
    
    func logoutTapped(sender:UIButton) {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.navigateToOnboardingView()
    }
    
    func setupMapView() {
        mapView.mapType = .HybridFlyover
        mapView.delegate = self
        
        mapView.addAnnotations(placeList!)
    }
    
    func setupTableView () {
        self.tableView.registerClass(SpotTableViewCell.self, forCellReuseIdentifier: "spotTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
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
        cell.cellImage.imageFromUrl(place.logoURL!)
        
        // Set cell date
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MM/dd/yyyy, HH:mm a"
        let convertedDate:String = dateFormatter.stringFromDate(place.date)
        cell.dateLabel.text = convertedDate
        
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
            
            self.mapView.removeAnnotation(self.placeList![indexPath.row])

            // remove the item from the data model
            self.placeList?.removeAtIndex(indexPath.row)
            
            // delete the table view row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
        delete.backgroundColor = UIColor.redColor()
        
        // Favorite or unfavorite action
        var favorite = UITableViewRowAction()
        if !placeList![indexPath.row].favorite {
            favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
            print("Favorite tapped")
                
            self.placeList![indexPath.row].favorite = true
            self.mapView(self.mapView, viewForAnnotation: self.placeList![indexPath.row])
            }
        }
        else {
            favorite = UITableViewRowAction(style: .Normal, title: "Un-favorite") { action, index in
                print("Un-avorite tapped")
                self.placeList![indexPath.row].favorite = false
            }
        }
        favorite.backgroundColor = UIColor.orangeColor()
        
        
        return [favorite, delete]
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let anView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")

        let place: Place = annotation as! Place
        var pinImage:String
        if place.favorite {
            pinImage = "yellowPin.png"
        }
        else {
            pinImage = "redPin.png"
        }
        
        let pin = UIImage(named: pinImage)
        let size = CGSize(width: 21.91919191, height: 35)
        UIGraphicsBeginImageContext(size)
        pin!.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        anView.image = resizedImage
        anView.canShowCallout = true
        
        return anView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
