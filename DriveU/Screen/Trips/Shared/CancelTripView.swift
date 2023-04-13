//
//  CancelTripView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/13/23.
//

import SwiftUI

struct CancelTripView: View {
    @Binding var mapViewState: MapViewState
    var body: some View {
        
        VStack{
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray)
                .opacity(0.7)
                .frame(width: 30,height: 5)
                .padding()
            
            Text("This trip has been cancelled.")
                .font(.title2)
                .fontWeight(.semibold)
            
            Button {
                mapViewState = .noInput
            } label: {
                
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                    .frame(width: UIScreen.main.bounds.width*0.6,height: 60)
                    .overlay(
                        Text("OK")
                            .font(.title3)
                            .foregroundColor(.white)
                    )
            }

        }.padding()
        .background(Color.theme.backGroundColor)
        .cornerRadius(10)
    }
}

struct CancelTripView_Previews: PreviewProvider {
    static var previews: some View {
        CancelTripView(mapViewState: .constant(.driverReject))
    }
}
