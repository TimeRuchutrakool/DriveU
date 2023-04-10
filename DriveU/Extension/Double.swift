//
//  Double.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import Foundation

extension Double{
    
    private var currencyFormatter: NumberFormatter{
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        return formatter
    }
    
    func toCurrency() -> String{
        return "B\(currencyFormatter.string(from:self as NSNumber) ?? "")"
    }
    
}
