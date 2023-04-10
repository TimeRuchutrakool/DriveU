//
//  LocationSearchView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/9/23.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject var locationSearchViewModel: LocationSearchViewModel
    @Binding var mapViewState: MapViewState
    
    var body: some View {
        VStack{
            //MARK: - Header
            HStack{
                VStack{
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 7)
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.gray)
                        .frame(width: 4,height: 40)
                    Rectangle()
                        .frame(width: 7,height: 7)
                }
                VStack{
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.searchTextFieldBackGround)
                        .frame(height: 50)
                        .overlay(
                            Text("Current Location")
                                .foregroundColor(Color(.systemGray3))
                                .padding(.leading)
                            ,alignment: .leading
                        )
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.theme.searchTextFieldBackGround)
                        .frame(height: 50)
                        .overlay(
                            TextField("Where to?", text: $locationSearchViewModel.queryFragment)
                        .padding(.leading)
                    )
                }
            }.padding()
                .padding(.top,UIScreen.main.bounds.height*0.06)
            //MARK: - Body
            ScrollView(showsIndicators: false) {
                ForEach(locationSearchViewModel.results,id: \.self){ result in
                    LocationSearchedCell(title: result.title, subtitle: result.subtitle)
                        .onTapGesture {
                            withAnimation(.spring()){
                                locationSearchViewModel.selectedLocationSearching(result)
                                mapViewState = .locationSelected
                            }
                        }
                }
            }
        }
        
        .background(Color.theme.backGroundColor)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapViewState: .constant(.noInput)).environmentObject(LocationSearchViewModel())
    }
}
