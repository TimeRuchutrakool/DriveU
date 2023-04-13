//
//  SidebarViewModel.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import Foundation

enum SidebarViewModel: Int,CaseIterable,Identifiable{
    
    case trips
    case wallet
    case settings
    case messages
    
    var id: Int{
        return rawValue
    }
    
    var title:String{
        switch self{
        case .trips:
            return "Your Trips"
        case .wallet:
            return "Your Wallet"
        case .settings:
            return "Settings"
        case .messages:
            return "Messages"
        }
    }
    
    var image: String{
        switch self{
        case .trips:
            return "list.bullet.clipboard"
        case .wallet:
            return "creditcard"
        case .settings:
            return "gearshape.fill"
        case .messages:
            return "message"
        }
    }
    
}
