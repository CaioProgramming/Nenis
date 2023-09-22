//
//  AuthViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 21/09/23.
//

import Foundation
import FirebaseAuth

protocol AuthProtocol {
    func loginSuccess(userName: String?)
    func loginError()
    func signUpSuccess(userName: String?)
    func signUpError()
}

class AuthViewModel {
    
    var authDelegate: AuthProtocol? = nil
    
    func handleAuthComplete(isLogin: Bool, authResult: AuthDataResult?, authError: Error?) {
        if let errorResult = authError {
            let authError = errorResult as NSError
            print(authError.debugDescription)
            if(isLogin) {
                self.authDelegate?.loginError()

            } else {
                self.authDelegate?.signUpError()
            }
            return
        }
        if let authComplete = authResult {
            print(authComplete.debugDescription)
            if(isLogin) {
                self.authDelegate?.loginSuccess(userName: authComplete.user.displayName)

            } else {
                self.authDelegate?.signUpSuccess(userName: authComplete.user.displayName)
            }
            return
        }
    }
    
    func loginUser(email: String, password: String) {
        print("Authenticating... \(email) / \(password)")
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.handleAuthComplete(isLogin: true, authResult: authResult, authError: error)
        }
    }
    
    func signUpUser(email: String, password: String, username: String) {
        print("Registering... \(username) \(email) / \(password)")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges { error in
                if let updateError = error {
                    print(updateError.localizedDescription)
                    self.authDelegate?.signUpError()
                } else {
                    self.handleAuthComplete(isLogin: false, authResult: authResult, authError: error)

                }   
            }
        }
    }
    
}
