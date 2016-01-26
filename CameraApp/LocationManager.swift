//
//  LocationManager.swift
//  CameraApp
//
//  Created by Will Wyatt on 1/25/16.
//  Copyright © 2016 Will Wyatt. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager:NSObject {
    private var manager:CLLocationManager = CLLocationManager()
    let NSLocationAlwaysUsageDescription = "The Camera App wishes to use Location Services"
    let NSLocationWhenInUseUsageDescription = "The Camera App wishes to use Location Services while in use"
    
    override init() {
        super.init()
        
        self.manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.manager.distanceFilter = 500
        self.manager.requestWhenInUseAuthorization()
        self.manager.startUpdatingLocation()
    }
    
    func getCurrentLoction() -> (lat: String, long: String)? {
        guard let loc = self.manager.location else {
            return nil
        }
        return (lat:"\(loc.coordinate.latitude)", long:"\(loc.coordinate.longitude)")
    }
}