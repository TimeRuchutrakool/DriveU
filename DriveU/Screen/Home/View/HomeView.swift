//
//  ContentView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct HomeView: View {
    @State private var mapViewState: MapViewState = .noInput
    @State private var sidebarToggling = false
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        
        if authViewModel.userSession == nil{
            LogInView()
        }
        else if let user = authViewModel.currentUser{
            NavigationStack{
                ZStack{
                    
                    if sidebarToggling{
                        SidebarView(user: user)
                    }
                    mapView
                        .offset(x: sidebarToggling ? UIScreen.main.bounds.width*0.7 : 0)
                        .edgesIgnoringSafeArea(.bottom)
                    
                    
                }
            }
            .onAppear(){
                sidebarToggling = false
            }
        }
    }
}
extension HomeView{
    var mapView: some View{
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
                if mapViewState == .noInput || mapViewState == .locationSelected || mapViewState == .searchingLocation || mapViewState == .polylineAdded||mapViewState == .driverReject{
                    HStack {
                        MapActionButton(mapViewState: $mapViewState, sidebarToggling: $sidebarToggling)
                        Spacer()
                    }
                }
            }
            if homeViewModel.currentUser?.accountType == .passenger{
                
                if mapViewState == .locationSelected || mapViewState == .polylineAdded{
                    TripRequestView(mapViewState: $mapViewState)
                        .transition(.move(edge: .bottom))
                }
                else if mapViewState == .tripRequesting{
                    WatingForAcceptionView()
                        .offset(y: -100)
                        .transition(.move(edge: .bottom))
                }
                else if mapViewState == .tripAccepted{
                    if let trip = homeViewModel.trip{
                        DriverView(trip: trip)
                            .transition(.move(edge: .bottom))
                    }
                }
                else if mapViewState == .driverReject{
                    CancelTripView(mapViewState: $mapViewState)
                        .offset(y: -100)
                        .transition(.move(edge: .bottom))
                }
                
            }
            else if homeViewModel.currentUser?.accountType == .driver{
                if let trip = homeViewModel.trip{
                    if mapViewState == .tripRequesting{
                        TripAcceptionView(trip: trip)
                            .transition(.move(edge: .bottom))
                    }
                    else if mapViewState == .tripAccepted{
                        PassengerView(trip: trip)
                            .transition(.move(edge: .bottom))
                    }
                    else if mapViewState == .driverReject{
                        CancelTripView(mapViewState: $mapViewState)
                            .offset(y: -100)
                            .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .onReceive(LocationManager.shared.$userLocation) { location in
            if let location = location{
                homeViewModel.userLocation = location
            }
        }
        .onReceive(homeViewModel.$trip) { trip in
            guard let trip = trip else {return}
            switch trip.state{
            case .tripRequested:
                mapViewState = .tripRequesting
            case .tripRejected:
                mapViewState = .driverReject
            case .tripAccepted:
                mapViewState = .tripAccepted
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(AuthenticationViewModel()).environmentObject(HomeViewModel())
    }
}
