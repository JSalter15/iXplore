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
    
    func changeFavoritePlace(place:Place)
    {
        //update allPlaces[]
        getPlaces()
        
        // the index is found if the title and the date are the same. That's enough to know
        if let index = places.indexOf({$0.title == place.title && $0.date == place.date}) {
            let placeToUpdate = places[index]
            
            if placeToUpdate.favorite {
                placeToUpdate.favorite = false
            }
            else {
                placeToUpdate.favorite = true
            }
            
            // update the array
            PersistenceManager.saveNSArray(places, fileName: "places")
        }
    }
    
    func removePlace(place:Place)
    {
        getPlaces()
        
        // the index is found if the title and the date are the same. That's enough to know
        if let index = places.indexOf({$0.title == place.title && $0.date == place.date})
        {
            // remove the place
            places.removeAtIndex(index)
            
            // update the array
            PersistenceManager.saveNSArray(places, fileName: "places")
        }
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