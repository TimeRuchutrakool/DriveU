//
//  RideType.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import Foundation

enum RideType: Int,CaseIterable,Identifiable{
    case regular
    case large
    
    var id: Int{
        self.rawValue
    }
    
    var image:String{
        switch self{
        case .regular:
            return "regular"
        case .large:
            return "large"
        }
    }
    var title: String{
        switch self{
        case .regular:
            return "RegularU"
        case .large:
            return "LargeU"
        }
    }
    var subtitle: String{
        switch self{
        case .regular:
            return "1 - 4 persons"
        case .large:
            return "5 - 6 persons"
        }
    }
    var basePrice:Double{
        switch self{
        case .regular:
            return 70.0
        case .large:
            return 120.0
        }
    }
    func computePrice(distance: Double) -> Double{
        let miles = distance/1600
        switch self{
        case .regular:
            return basePrice + miles*2.0
        case .large:
            return basePrice + miles*4
        }
    }
    
}
