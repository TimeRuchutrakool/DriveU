//
//  Driver.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import Foundation
import CoreLocation
import MapKit

class DriverAnnotation: NSObject,MKAnnotation{
    
    let uid: String
    let coordinate: CLLocationCoordinate2D
    
    init(driver: User) {
        self.uid = driver.uid
        self.coordinate = CLLocationCoordinate2D(latitude: driver.coordinate.latitude, longitude: driver.coordinate.longitude)
    }
    
}
