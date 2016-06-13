//
//  MapTableViewController.swift
//  iXplore
//
//  Created by Joe Salter on 6/8/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import UIKit
import MapKit

class MapTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    
    var placeList:[Place]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.placeList = Place.placeList()
        
        setupMapView()
        setupTableView()
    }
    
    func setupMapView() {
        mapView.mapType = .HybridFlyover
        
        for place in placeList! {
            mapView.addAnnotation(place)
        }
    }
    
    func setupTableView () {
        self.tableView.registerNib(UINib(nibName: "SpotTableViewCell", bundle: nil), forCellReuseIdentifier: "SpotTableViewCell")
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("SpotTableViewCell") as! SpotTableViewCell
        cell.titleLabel.text = place.title
        cell.cellImage.imageFromUrl(place.logoURL!)
        
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
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            // remove the item from the data model
            placeList?.removeAtIndex(indexPath.row)
            
            // delete the table view row
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
