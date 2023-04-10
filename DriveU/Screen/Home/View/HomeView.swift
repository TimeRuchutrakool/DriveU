//
//  ContentView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct HomeView: View {
    @State private var mapViewState: MapViewState = .noInput
    var body: some View {
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
