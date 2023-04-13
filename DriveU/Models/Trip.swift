//
//  Trip.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum TripState:Int,Codable{
    case tripRequested
    case tripRejected
    case tripAccepted
}

struct Trip: Identifiable,Codable{
    
    @DocumentID var tripId: String?
    
    var id: String{
        tripId ?? ""
    }
    
    let passengerUid: String
    let passengerName: String
    let passengerCoordinate: GeoPoint
    let driverUid: String
    let driverName: String
    let driverCoordinate: GeoPoint
    let pickUpLocationName: String
    let pickUpLocationAddress: String
    let pickUpLocationCoordinate: GeoPoint
    let dropOffLocationName: String
    let dropOffLocationAddress: String
    let dropOffLocationCoordinate: GeoPoint
    
    let tripCosts: Double
    var distanceToPassenger: Double
    var travelTimeToPassenger: Int
    var state: TripState
}
