//
//  SettingsView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        VStack{
            List{
                Section{
                    //MARK: - User Card
                    
                    HStack{
                        Image("driver")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40,height: 40)
                            .clipShape(Circle())
                        VStack(alignment: .leading){
                            Text("Username")
                                .font(.title2)
                                .foregroundColor(Color.theme.primaryTextColor)
                            Text("Email")
                                .foregroundColor(.gray)
                        }
                        .padding(.leading)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .padding()
                    }
                    
                }
                //MARK: - Account
                Section("Account") {
                    HStack{
                        Image(systemName: "steeringwheel")
                            .imageScale(.large)
                            .foregroundColor(Color.green)
                        Text("Become a driver")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.theme.primaryTextColor)
                    }
                    .padding(8)
                    Button {
                        authViewModel.logout()
                    } label: {
                        HStack{
                            Image(systemName: "arrow.left.square.fill")
                                .imageScale(.large)
                                .foregroundColor(Color.red)
                            Text("Log Out")
                                .fontWeight(.semibold)
                                .foregroundColor(Color.theme.primaryTextColor)
                        }
                        .padding(8)
                    }
                    
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
