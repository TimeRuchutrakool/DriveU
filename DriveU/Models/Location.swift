//
//  Location.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import Foundation
import CoreLocation

struct Location: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subtitle: String
    var coordinate: CLLocationCoordinate2D
}
