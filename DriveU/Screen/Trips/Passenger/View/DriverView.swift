//
//  DriverView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/13/23.
//

import SwiftUI

struct DriverView: View {
    let trip: Trip
    @State private var caranimating = false
    @State private var circleanimating = 0.0
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
                Text("Meet your driver at \(trip.pickUpLocationName) for your ride to \(trip.dropOffLocationName)")
                    .font(.title3)
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
            
            HStack{
                Image("driver")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70,height: 70)
                VStack(alignment:.leading) {
                    Text(trip.driverName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Honda Freed")
                        .font(.title3)
                        .foregroundColor(.gray)
                }
                Spacer()
                ZStack {
                    
                    Circle().stroke(lineWidth: 1)
                        .frame(width: 40,height: 40)
                        .scaleEffect(1 + CGFloat(circleanimating))
                        .opacity(1 - circleanimating)
                    
                    Image(systemName: "car.rear.road.lane")
                        .imageScale(.large)
                        .scaleEffect(caranimating ? 1.5 : 1)
                }
                
            }.padding(.horizontal,20)
                .padding(.vertical)
            Spacer()
                .frame(height: 100)
        }
        .onAppear(){
            withAnimation(.easeInOut(duration: 1).repeatForever()){
                caranimating = true
            }
            withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)){
                circleanimating = 1
            }
        }
        .background(Color.theme.backGroundColor)
        .cornerRadius(20, corners: [.topLeft,.topRight])
    }
    
}

struct DriverView_Previews: PreviewProvider {
    static var previews: some View {
        DriverView(trip: mock.mockTrip)
    }
}
