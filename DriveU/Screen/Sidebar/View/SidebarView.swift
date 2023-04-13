//
//  SidebarView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import SwiftUI
import Firebase

struct SidebarView: View {
    let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var body: some View {
        
            VStack(alignment: .leading){
                //MARK: - Profile Image
                HStack{
                    Image("driver")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40,height: 40)
                        .clipShape(Circle())
                        .padding()
                    VStack(alignment: .leading){
                        Text(user.username)
                            .foregroundColor(Color.theme.primaryTextColor)
                        Text(user.email)
                            .foregroundColor(.gray)
                    }
                }
                Divider()
                
                //MARK: - Body
                ForEach(SidebarViewModel.allCases){ option in
                    NavigationLink(value: option) {
                        SidebarOptionView(option: option)
                    }
                    
                }
                .navigationDestination(for: SidebarViewModel.self) { viewModel in
                    switch viewModel{
                    case .trips:
                        Text("")
                    case .wallet:
                        Text("")
                    case .settings:
                        SettingsView()
                    case .messages:
                        Text("")
                    }
                }
                
                //MARK: - Become a Driver
                
                Text("Do more with your account")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding()
                HStack{
                    Image(systemName: "steeringwheel")
                        .imageScale(.large)
                        .foregroundColor(Color.theme.primaryTextColor)
                    Text("Become a driver")
                        .foregroundColor(Color.theme.primaryTextColor)
                }
                .font(.headline)
                .padding(.leading)
                
                Spacer()
            }
            .background(Color.theme.backGroundColor)
        
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView(user: User(uid: "", username: "", email: "",accountType: .passenger,coordinate: GeoPoint(latitude: 0, longitude: 0)))
    }
}
