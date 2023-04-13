//
//  LogInView.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import SwiftUI

struct LogInView: View {
    @State private var isAnimating = false
    @State private var emailText = ""
    @State private var passwordText = ""
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    var body: some View {
        NavigationStack{
            ZStack{
                Color("LoginColor")
                    .ignoresSafeArea()
                VStack(){
                    ZStack {
                        Image("wheel")
                            .resizable()
                            .scaledToFit()
                            .scaleEffect(isAnimating ? 1 : 0.5)
                            .rotationEffect(Angle(degrees: isAnimating ? 0 : 180))
                            .opacity(isAnimating ? 0.65 : 0)
                            .frame(width: 250)
                        Text("DriveU")
                            .font(.system(size: 90,design: .serif))
                            .fontWeight(.heavy)
                            .foregroundColor(Color(.white))
                            .offset(y:isAnimating ? 0 : 30)
                            .opacity(isAnimating ? 1 : 0.7)
                    }
                    
                    
                    //MARK: - Login Form
                    VStack(alignment:.leading){
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
                    
                    Button {
                        authViewModel.login(email: emailText, password: passwordText)
                    } label: {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.6))
                            .frame(width: UIScreen.main.bounds.width*0.5,height: 60)
                            .overlay(
                                Text("LOGIN")
                                    .foregroundColor(.white)
                                    .font(.title)
                                    .fontWeight(.heavy)
                            )
                            .padding()
                    }
                    Spacer()
                    
                    HStack{
                        Text("Don't have an account?")
                            .foregroundColor(.white)
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Text("Sign Up")
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                        }
                    }
                    
                    Spacer()
                }
            }
            .onAppear(){
                withAnimation(.spring()){
                    isAnimating = true
                }
            }
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
