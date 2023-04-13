//
//  SidebarOptionView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import SwiftUI

struct SidebarOptionView: View {
    let option: SidebarViewModel
    var body: some View {
        HStack{
            Image(systemName: option.image)
                .imageScale(.large)
                .foregroundColor(Color.theme.primaryTextColor)
            Text(option.title)
                .foregroundColor(Color.theme.primaryTextColor)
            Spacer()
        }
        .font(.headline)
        .padding(.leading)
        .padding(.top)
    }
}

struct SidebarOptionView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarOptionView(option: .wallet)
    }
}
