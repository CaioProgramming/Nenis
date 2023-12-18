//
//  UserHelper.swift
//  Nenis
//
//  Created by Caio Ferreira on 14/12/23.
//

import Foundation
import FirebaseAuth
import os

class UserHelper  {
    typealias T = Tutor
    
    
    var userService: UserService = UserService()
   
    init(_ userService: UserService? = nil) {
       initialize()
    }
    
    func initialize() {
        self.userService = UserService()
    }
    
    
    func queryUserID(id: String, with userClosure: @escaping (Tutor?) -> ()) {
        Task {
            await userService.getSingleData(id: id, onSuccess: { tutor in  userClosure(tutor) } , onFailure: { _ in userClosure(nil)})
        }
    }
    
    func getUser(user: User) {
        Task {
            await userService.getSingleData(id: user.uid, onSuccess: { _ in} , onFailure: { _ in
                self.updateUser(user: user)
            })
        }
    }
    
    func updateUser(user: User) {
        Task {
            let tutor = Tutor(id: user.uid, name: user.displayName, photoURL: user.photoURL?.absoluteString)
            await userService.updateData(data: tutor, onSuccess: { _ in }, onFailure: { _ in })
        }
    }
    
}
