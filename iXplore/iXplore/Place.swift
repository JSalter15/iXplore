//
//  Place.swift
//  
//
//  Created by Joe Salter on 6/8/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation
import MapKit

class Place: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var title: String?
    var logoURL: String?
    var descriptor: String?
    var date: NSDate?
    var favorite: Bool = false
    
    class func placeList() -> [Place] {
        
        var placeList:[Place] = []
        
        let place = Place()
        place.title = "Workshop 17"
        place.logoURL = "https://avatars1.githubusercontent.com/u/7220596?v=3&s=200"
        place.coordinate = CLLocationCoordinate2D(latitude: -33.906764,longitude: 18.4164983)
        place.favorite = true
        placeList.append(place)
        
        let place2 = Place()
        place2.title = "Truth Coffee"
        place2.logoURL = "https://robohash.org/123.png"
        place2.coordinate = CLLocationCoordinate2D(latitude: -33.9281976,longitude: 18.4227045)
        placeList.append(place2)

        let place3 = Place()
        place3.title = "Chop Chop Coffee"
        place3.logoURL = "https://pbs.twimg.com/profile_images/723083135815192576/XTFGfEJe.jpg"
        place3.coordinate = CLLocationCoordinate2D(latitude: -33.9271879,longitude: 18.4327055)
        placeList.append(place3)
        
        return placeList
    }
}

extension UIImageView   {
    
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
                if let imageData = data as NSData? {
                    self.image = UIImage(data: imageData)
                }
            }
        }
    }
    
}
