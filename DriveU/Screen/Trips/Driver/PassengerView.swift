//
//  PassengerView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/13/23.
//

import SwiftUI

struct PassengerView: View {
    let trip : Trip
    @EnvironmentObject var homeViewModel: HomeViewModel

    init(trip: Trip) {
        self.trip = trip
    }
    
    var body: some View {
        VStack{
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray)
                .opacity(0.7)
                .frame(width: 30,height: 5)
                .padding()
            
            HStack{
                Text("Pick \(trip.passengerName) up at \(trip.pickUpLocationName)")
                    .font(.title3)
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.blue)
                    .frame(width: 50,height: 50)
                    .overlay(
                        VStack{
                            Text("\(trip.travelTimeToPassenger)")
                            Text("min")
                        }.foregroundColor(.white)
                    )
            }.padding(.horizontal)
            Divider()
            HStack{
                Image("driver")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70,height: 70)
                Text(trip.passengerName)
                    .font(.title3)
                    .fontWeight(.semibold)
                Spacer()
                VStack(alignment: .center) {
                    Text("Earnings")
                    Text(trip.tripCosts.toCurrency())
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .padding(.horizontal)
            Button {
                homeViewModel.rejectTrip()
            } label: {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.red)
                    .frame(width: UIScreen.main.bounds.width*0.6,height: 60)
                    .padding()
                    .overlay(
                        Text("Cancel Trip").foregroundColor(.white).font(.title2).fontWeight(.semibold)
                    )
            }
            Spacer()
                .frame(height: 100)
            
        }
        .background(Color.theme.backGroundColor)
        .cornerRadius(20, corners: [.topLeft,.topRight])
    }
}

struct PassengerView_Previews: PreviewProvider {
    static var previews: some View {
        PassengerView(trip: mock.mockTrip).environmentObject(HomeViewModel())
    }
}
