//
//  RideTypeCard.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import SwiftUI

struct RideTypeCard: View {
    let type: RideType
    @Binding var selectedRideType: RideType
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        
        RoundedRectangle(cornerRadius: 16)
            .fill(selectedRideType == type ? Color.blue : Color.theme.secondaryBackGroundColor)
            .frame(width: UIScreen.main.bounds.width*0.45,height: UIScreen.main.bounds.width*0.55)
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
                                .font(.title2)
                                .foregroundColor(selectedRideType == type ? Color.white : Color.theme.primaryTextColor)
                            Text(type.subtitle)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .foregroundColor(selectedRideType == type ? Color.white : .gray)
                            Text(homeViewModel.computeRidePrice(type: type).toCurrency())
                                .fontWeight(.semibold)
                                .font(.title2)
                                .foregroundColor(selectedRideType == type ? Color.white : Color.theme.primaryTextColor)
                        }
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                    
                    
                }.scaleEffect(selectedRideType == type ? 1.0 : 0.8)
            )
        
    }
}

struct RideTypeCard_Previews: PreviewProvider {
    static var previews: some View {
        RideTypeCard(type: .regular, selectedRideType: .constant(.regular))
            .environmentObject(HomeViewModel())
            .previewLayout(.sizeThatFits)
    }
}
