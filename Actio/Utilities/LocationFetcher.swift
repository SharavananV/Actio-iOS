//
//  LocationFetcher.swift
//  Actio
//
//  Created by apple on 15/09/20.
//  Copyright © 2020 Knila. All rights reserved.
//

import Foundation
import CoreLocation

class LocationFetcher: NSObject, CLLocationManagerDelegate {
    static let shared = LocationFetcher()
    
    private override init() {}
    
    private let locationManager = CLLocationManager()
    private var lastUpdatedLocation: CLLocation?
    var currentCoordinates: CLLocationCoordinate2D? {
        return lastUpdatedLocation?.coordinate
    }
    
    func getCurrentCoordinates() {
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Check the accuracy of the updated location
        if let updatedLocation = locations.last {
            let distance = lastUpdatedLocation?.distance(from: updatedLocation)
            
            // check if distance is greater than 1KM
            if let distance = distance, distance > 1000 {
                NotificationCenter.default.post(.locationUpdated, object: nil)
            }
        }
        
        lastUpdatedLocation = locations.last
    }
}
