//
//  LocationManager.swift
//  Sensors
//
//  Created by Vikhyath on 13/02/19.
//  Copyright © 2019 Vikhyath. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager()
    var locationManager = CLLocationManager()
    
    private override init() {
        
        super.init()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func startLocationUpdates() {
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }
}
