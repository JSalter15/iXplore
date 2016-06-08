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
        
        if (place.ratable) {
            let cell = tableView.dequeueReusableCellWithIdentifier("SpotTableViewCell") as! SpotTableViewCell
            cell.label.text = place.title
            cell.cellImage.imageFromUrl(place.logoURL!)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("SpotTableViewCell") as! SpotTableViewCell
            cell.textLabel?.text = place.title
            cell.cellImage.imageFromUrl(place.logoURL!)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let place = placeList![indexPath.row]
        
        if place.ratable {
            return 88
        }
        else {
            return 44
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
