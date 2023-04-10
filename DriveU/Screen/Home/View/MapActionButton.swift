//
//  MapActionButton.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct MapActionButton: View {
    @Binding var mapViewState: MapViewState
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
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
        
            switch state {
            case .noInput:
                break
            case .searchingLocation:
                mapViewState = .noInput
            case .locationSelected:
                mapViewState = .noInput
                locationSearchViewModel.selectedLocation = nil
            }
        
    }
    func imageForState(_ state: MapViewState) -> String{
        switch state {
        case .noInput:
            return "line.3.horizontal"
        case .searchingLocation:
            return "arrow.left"
        case .locationSelected:
            return "arrow.left"
        }
    }
}

struct MapActionButton_Previews: PreviewProvider {
    static var previews: some View {
        MapActionButton(mapViewState: .constant(.noInput)).previewLayout(.sizeThatFits)
            .background(Color.black)
    }
}
