//
//  MapViewState.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import Foundation

enum MapViewState{
    case noInput
    case searchingLocation
    case locationSelected
    case polylineAdded
    case tripRequesting
    case tripAccepted
    case driverReject
}
