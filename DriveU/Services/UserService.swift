//
//  UserService.swift
//  DriveU
//
//  Created by Time Ruchutrakool on 4/11/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class UserService: ObservableObject{
    
    static let shared = UserService()

    @Published var user: User?

    init(){
        fetchUser()
        
    }

    func fetchUser(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            guard let snapshot = snapshot else {return}
            let currentUser = try? snapshot.data(as: User.self)
            self.user = currentUser

        }
    }
}
