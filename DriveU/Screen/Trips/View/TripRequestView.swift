//
//  TripRequestView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import SwiftUI

struct TripRequestView: View {
    var body: some View {
        VStack{
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray)
                .opacity(0.7)
                .frame(width: 30,height: 5)
                .padding()
            //MARK: - Locations
            
            HStack{
                VStack{
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 7)
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray)
                        .frame(width: 4,height: 20)
                    Rectangle()
                        .fill(.gray)
                        .frame(width: 7,height: 7)
                }
                
                VStack(alignment: .leading){
                    HStack{
                        Text("Current Location")
                        Spacer()
                        Text("10:20 AM")
                    }
                    .foregroundColor(.gray)
                    .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.bottom)
                    HStack{
                        Text("Destination Location")
                        Spacer()
                        Text("10:20 AM")
                    }.foregroundColor(Color.theme.primaryTextColor)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
            }.padding(.horizontal)
            
            Divider()
            //MARK: - Vehicle Types
            
            VStack(alignment: .leading){
                Text("Suggested Ride".uppercased())
                    .foregroundColor(.gray)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack{
                        ForEach(RideType.allCases) { type in
                            RideTypeCard(type: type)
                        }
                    }
                }
            }.padding(.horizontal)
            
            
            //MARK: - Credit Card
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.theme.secondaryBackGroundColor)
                .frame(width: UIScreen.main.bounds.width*0.9,height: 50)
                .overlay(
                    HStack{
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 60)
                            .overlay(Text("Visa").foregroundColor(.white).fontWeight(.heavy))
                            .padding(7)
                        Text("**** 1234")
                            .foregroundColor(Color.theme.primaryTextColor)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color.theme.primaryTextColor)
                            .padding()
                    }
                )
            
            //MARK: - Confirm Ride Button
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.blue)
                .frame(width: UIScreen.main.bounds.width*0.9,height: 50)
                .overlay(
                    Text("Confirm Ride".uppercased())
                        .foregroundColor(Color.white)
                        .font(.title3)
                        .fontWeight(.bold)
                )
          Spacer()
                .frame(height: 35)
        }
        .background(Color.theme.backGroundColor)
        .cornerRadius(20, corners: [.topLeft,.topRight])
 
    }
}

struct TripRequestView_Previews: PreviewProvider {
    static var previews: some View {
        TripRequestView().environmentObject(LocationSearchViewModel())
    }
}
