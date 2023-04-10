//
//  ContentView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct HomeView: View {
    @State private var mapViewState: MapViewState = .noInput
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    var body: some View {
        ZStack(alignment: .bottom) {
            
            ZStack(alignment: .top){
                
                MapRepresentable(mapViewState: $mapViewState)
                    .ignoresSafeArea()
                
                
                
                if mapViewState == .searchingLocation{
                    
                    LocationSearchView(mapViewState: $mapViewState)
                    
                }
                else if mapViewState == .noInput{
                    StartSearchingLocationButton()
                        .offset(y:UIScreen.main.bounds.height*0.12)
                        .onTapGesture {
                            withAnimation(.spring()){
                                mapViewState = .searchingLocation
                            }
                        }
                }
                
                HStack {
                    MapActionButton(mapViewState: $mapViewState)
                    Spacer()
                }
                
            }
            if mapViewState == .locationSelected{
                TripRequestView()
                    .transition(.move(edge: .bottom))
            }
        }.edgesIgnoringSafeArea(.bottom)
            .onReceive(LocationManager.shared.$userLocation) { location in
                if let location = location{
                    locationSearchViewModel.userLocation = location
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
