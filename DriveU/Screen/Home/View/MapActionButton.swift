//
//  MapActionButton.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct MapActionButton: View {
    @Binding var mapViewState: MapViewState
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var sidebarToggling: Bool
    var body: some View {
        Button {
            withAnimation(.spring()){
                actionForState(mapViewState)
            }
        } label: {
            RoundedRectangle(cornerRadius:10)
                .fill(Color.white)
                .frame(width: 40,height: 40)
                .shadow(radius: 5)
                .padding()
                .overlay(
                Image(systemName: imageForState(mapViewState))
                    .imageScale(.medium)
                    .foregroundColor(Color.black)
                )
        }

    }
    func actionForState(_ state: MapViewState){
        withAnimation(.spring()){
            switch state {
            case .noInput:
                sidebarToggling.toggle()
            case .searchingLocation:
                mapViewState = .noInput
            case .locationSelected,.polylineAdded,.driverReject:
                mapViewState = .noInput
                homeViewModel.selectedLocation = nil
            case .tripRequesting,.tripAccepted:
                break
            }
        }
    }
    func imageForState(_ state: MapViewState) -> String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingLocation,.locationSelected,.polylineAdded,.driverReject:
            return "arrow.left"
        case .tripRequesting,.tripAccepted:
            return ""
        }
    }
}

struct MapActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapActionButton(mapViewState: .constant(.noInput), sidebarToggling: .constant(false)).previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}
