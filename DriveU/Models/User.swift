//
//  User.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 5/15/23.
//

import Foundation
import Firebase

enum AccountType: Int,Codable{
    case passenger
    case driver
}

struct User: Codable{
    let username: String
    let email: String
    let uid: String
    var accountType: AccountType
    var coordinate: GeoPoint //track user current location
}
