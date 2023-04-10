//
//  LocationManager.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import Foundation
import CoreLocation

class LocationManager: NSObject,ObservableObject{
    let locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationManager: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else {return}
        locationManager.stopUpdatingLocation()
    }
}
