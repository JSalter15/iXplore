//
//  PlacesController.swift
//  iXplore
//
//  Created by Joe Salter on 6/14/16.
//  Copyright © 2016 Joe Salter. All rights reserved.
//

import Foundation

class PlacesController {
    
    class var sharedInstance: PlacesController {
        struct Static {
            static var instance:PlacesController?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token)    {
            Static.instance = PlacesController()
        }
        return Static.instance!
    }

    var places:[Place] = []
    
    func addPlace(place:Place) {
        place.date = NSDate()
        places.append(place)
        PersistenceManager.saveNSArray(places, fileName: "places")
    }
    
    private func readPlacesFromMemory() -> [Place] {
        if let placeArray = PersistenceManager.loadNSArray("places") {
            places = placeArray as! [Place]
        }
        return places
    }
    
    func getPlaces() -> [Place] {
        if places.count == 0 {
            return readPlacesFromMemory()
        }
        /*if places.count == 0 {
            return Place.placeList()
        }*/
        else {
            return places
        }
    }
}