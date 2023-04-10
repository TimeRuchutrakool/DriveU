//
//  StartSearchingLocationButton.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct StartSearchingLocationButton: View {
    
    var body: some View {
            HStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: UIScreen.main.bounds.width*0.85,height: 60)
                    .shadow(radius: 5)
                    .overlay(
                        HStack {
                            Text("Where to?")
                                .foregroundColor(.gray)
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.leading)
                            Spacer()
                            Image("driver")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .shadow(radius: 3,x: 5,y: 5)
                                .padding(.trailing)
                        }
                    )
            }
        
        
    }
    
}

struct StartSearchingLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        StartSearchingLocationButton()
    }
}
