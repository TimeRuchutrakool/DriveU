//
//  WaitingForAcceptionView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/13/23.
//

import SwiftUI

import SwiftUI
import ActivityIndicatorView

struct WatingForAcceptionView: View {
    @State private var isVisible = true
    var body: some View {
       RoundedRectangle(cornerRadius: 16)
            .fill(Color.theme.backGroundColor)
            .frame(width: UIScreen.main.bounds.width*0.9,height: 100)
            .overlay(
                HStack{
                    Text("Finding a driver")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.theme.primaryTextColor)
                    Spacer()
                    ActivityIndicatorView(isVisible: $isVisible, type: .scalingDots(count: 3, inset: 2))
                        .frame(width:50)
                        .foregroundColor(.blue)
                }
                    .padding()
            )
    }
}

struct WatingForAcceptionVIew_Previews: PreviewProvider {
    static var previews: some View {
        WatingForAcceptionView().previewLayout(.sizeThatFits)
    }
}
