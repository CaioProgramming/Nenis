//
//  HomeViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 19/09/23.
//

import Foundation
import FirebaseAuth

class HomeViewModel {
    
    
    func isUserLogged() -> Bool {
        
        let user = Auth.auth().currentUser
        
        return user != nil
        
        
    }
    
}
