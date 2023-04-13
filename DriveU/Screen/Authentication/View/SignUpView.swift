//
//  SignUpView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var usernameText = ""
    @State private var emailText = ""
    @State private var passwordText = ""
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        
        ZStack{
            Color("LoginColor")
                .ignoresSafeArea()
            
            VStack{
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        RoundedRectangle(cornerRadius:10)
                            .fill(Color.white)
                            .frame(width: 40,height: 40)
                            .shadow(radius: 5)
                            .padding()
                            .overlay(
                                Image(systemName: "arrow.left")
                                    .imageScale(.large)
                                    .foregroundColor(Color.black)
                            )
                    }
                    Text("SIGN UP")
                        .foregroundColor(.white)
                        .font(.system(.largeTitle))
                        .fontWeight(.heavy)
                    Spacer()
                }
               
                Spacer()
                //MARK: - Sign Up Form
                VStack(alignment: .leading) {
                    Text("USERNAME")
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: UIScreen.main.bounds.width*0.85,height: 60)
                        .overlay(
                            TextField("", text: $usernameText)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding()
                        )
                    Text("EMAIL")
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: UIScreen.main.bounds.width*0.85,height: 60)
                        .overlay(
                            TextField("", text: $emailText)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding()
                        )
                    Text("PASSWORD")
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.1))
                        .frame(width: UIScreen.main.bounds.width*0.85,height: 60)
                        .overlay(
                            SecureField("", text: $passwordText)
                                .foregroundColor(.white)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding()
                        )
                }
                Spacer()
                Button {
                    authViewModel.signup(username: usernameText, email: emailText, password: passwordText)
                } label: {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.blue.opacity(0.6))
                        .frame(width: UIScreen.main.bounds.width*0.5,height: 60)
                        .overlay(
                            Text("SIGN UP")
                                .foregroundColor(.white)
                                .font(.title)
                                .fontWeight(.heavy)
                        )
                        .padding()
                }
                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView().environmentObject(AuthenticationViewModel())
    }
}
