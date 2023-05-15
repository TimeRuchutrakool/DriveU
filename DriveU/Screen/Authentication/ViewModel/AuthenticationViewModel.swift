//
//  AuthenticationViewModel.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/10/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestoreSwift
import Combine

class AuthenticationViewModel: ObservableObject{
    
    let userService = UserService.shared
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        self.userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func fetchUser(){
        userService.$user.sink { user in
            guard let user = user else {return}
                self.currentUser = user
            
        }.store(in: &cancellable)
    }
    
    func login(email: String,password:String){
        Auth.auth().signIn(withEmail: email, password: password){ result, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let userSession = result?.user else { return }
            self.userSession = userSession
            self.fetchUser()
        }
    }
    
    func signup(username: String,email:String,password:String){
        guard let location = LocationManager.shared.userLocation else {return}
        Auth.auth().createUser(withEmail: email, password: password){ result, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let firebaseUser = result?.user else {return}
            let user = User(
                username: firebaseUser.uid,
                email: username,
                uid: email,
                accountType: .passenger,
                coordinate: GeoPoint(latitude: location.latitude, longitude: location.longitude)
            )
            self.userSession = firebaseUser
            self.currentUser = user
            guard let encodedData = try? Firestore.Encoder().encode(user) else {return}
            Firestore.firestore().collection("users").document(firebaseUser.uid).setData(encodedData)
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        }
        catch{
            print(error)
            return
        }
    }
    
}
