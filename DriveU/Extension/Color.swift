//
//  Color.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct Theme{
    let backGroundColor = Color("BackGroundColor")
    let primaryTextColor = Color("PrimaryTextColor")
    let secondaryBackGroundColor = Color("SecondaryBackGroundColor")
    let searchTextFieldBackGround = Color("SearchTextFieldBackGround")
}

extension Color{
    static let theme = Theme()
}
