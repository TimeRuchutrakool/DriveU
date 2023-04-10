//
//  RideTypeCard.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import SwiftUI

struct RideTypeCard: View {
    let type: RideType
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    var body: some View {
        
        RoundedRectangle(cornerRadius: 16)
            .fill(Color.theme.secondaryBackGroundColor)
            .frame(width: UIScreen.main.bounds.width*0.4,height: UIScreen.main.bounds.width*0.55)
            .overlay(
                VStack {
                    
                    Image(type.image)
                        .resizable()
                        .scaledToFit()
                        .shadow(radius: 5)

                    HStack {
                        VStack(alignment:.leading,spacing: 5) {
                            Text(type.title)
                                .fontWeight(.semibold)
                                .font(.title3)
                            Text(type.subtitle)
                                .fontWeight(.semibold)
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Text(locationSearchViewModel.computeRidePrice(type: type).toCurrency())
                                .fontWeight(.semibold)
                                .font(.title3)
                                .opacity(0.6)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    
                }
            )
        
    }
}

struct RideTypeCard_Previews: PreviewProvider {
    static var previews: some View {
        RideTypeCard(type: .regular)
            .environmentObject(LocationSearchViewModel())
            .previewLayout(.sizeThatFits)
    }
}
