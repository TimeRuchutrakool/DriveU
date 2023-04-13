//
//  TripAcceptionView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import SwiftUI
import MapKit

struct TripAcceptionView: View {
    
    @EnvironmentObject var homeViewModel: HomeViewModel
    let trip: Trip
    @State private var region : MKCoordinateRegion
    let annotation: Location
    
    init(trip: Trip){
        let center = CLLocationCoordinate2D(latitude: 13.72885, longitude: 100.51592)
        let span = MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015)
        region = MKCoordinateRegion(center: center, span: span)
        self.trip = trip
        self.annotation = Location(title: trip.pickUpLocationName, subtitle: trip.pickUpLocationAddress, coordinate: CLLocationCoordinate2D(latitude: trip.pickUpLocationCoordinate.latitude, longitude: trip.pickUpLocationCoordinate.longitude))
    }
    
    var body: some View {
        VStack{
            
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray)
                .opacity(0.7)
                .frame(width: 30,height: 5)
                .padding()
            //MARK: - Header
            HStack{
                Text("Would you like to pick up this passenger ?")
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .foregroundColor(Color.theme.primaryTextColor)
                    .fontWeight(.semibold)
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
            
            //MARK: - Driver Profile and Earnings
            
            HStack{
                //MARK: - Profile
                HStack{
                    Image("driver")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(trip.passengerName)
                            .foregroundColor(Color.theme.primaryTextColor)
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                Spacer()
                //MARK: - Earnings
                VStack(alignment:.center){
                    Text("Earnings")
                        .foregroundColor(Color.theme.primaryTextColor)
                    
                    Text(trip.tripCosts.toCurrency())
                        .foregroundColor(Color.theme.primaryTextColor)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }.padding(.horizontal)
            Divider()
            //MARK: - Passenget Location Map
            HStack{
                Text(trip.pickUpLocationName)
                    .font(.headline)
                
                Spacer()
                Text(String(format: "%.1f", trip.distanceToPassenger))
            }.padding(.horizontal).foregroundColor(Color.theme.primaryTextColor)
            HStack{
                Text(trip.pickUpLocationAddress)
                    .font(.footnote)
                    .foregroundColor(.gray)
                Spacer()
                Text("mi")
                    .foregroundColor(Color.theme.primaryTextColor)
            }.padding(.horizontal)
            
            Map(coordinateRegion: $region, annotationItems: [annotation]) { item in
                MapMarker(coordinate: item.coordinate)
            }
            .cornerRadius(16)
            .frame(maxWidth: .infinity,maxHeight: 200)
            .shadow(radius: 5)
            .padding(.horizontal)
            
            //MARK: - Accept and Reject Button
            HStack{
                //MARK: - Reject
                Button {
                    homeViewModel.rejectTrip()
                
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.red)
                        .frame(maxWidth: .infinity,maxHeight: 60)
                        .overlay(
                            Text("Reject")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        )
                }
                Spacer()
                //MARK: - Accept
                Button {
                    homeViewModel.acceptTrip()
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue)
                        .frame(maxWidth: .infinity,maxHeight: 60)
                        .overlay(
                            Text("Confirm")
                                .font(.title3)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        )
                }
            }.padding(.horizontal).padding(.vertical)
        }
        .background(Color.theme.backGroundColor)
        .cornerRadius(20, corners: [.topLeft,.topRight])
    }
}

struct TripAcceptionView_Previews: PreviewProvider {
    static var previews: some View {
        TripAcceptionView(trip: mock.mockTrip).environmentObject(HomeViewModel())
    }
}
