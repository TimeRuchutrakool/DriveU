//
//  MockData.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import Foundation
import Firebase
import SwiftUI

class MockData{
    
    static let shared = MockData()
    
    let mockuser = User(uid: "586k1Ids5wTrwQicScvDZZJy5ez1", username: "Time Ruchutrakool", email: "Test@gmail.com", accountType: .passenger, coordinate: GeoPoint(latitude: 13.731991, longitude: 100.52903294563293))
    
    
    let mockTrip = Trip(passengerUid: UUID().uuidString, passengerName: "Time Ruchu", passengerCoordinate:  GeoPoint(latitude: 13.72885, longitude: 100.51592), driverUid: UUID().uuidString, driverName: "Time R", driverCoordinate: GeoPoint(latitude: 13.72885, longitude: 100.51592), pickUpLocationName: "Siam Paragon", pickUpLocationAddress: "Brah Brah", pickUpLocationCoordinate: GeoPoint(latitude: 13.72885, longitude: 100.51592), dropOffLocationName: "Silom Complex", dropOffLocationAddress: "Ubah", dropOffLocationCoordinate: GeoPoint(latitude: 13.72885, longitude: 100.51592), tripCosts: 100, distanceToPassenger: 10, travelTimeToPassenger: 5, state: .tripRequested)
}

extension PreviewProvider{
    static var mock:MockData{
        MockData.shared
    }
}
