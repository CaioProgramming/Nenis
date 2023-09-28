//
//  HomeViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 19/09/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import os

protocol HomeProtocol {
    
    func childRetrieved(with child: Child)
    func childNotFound()
    func requireAuth()
    func authSuccess(user: User)
}


class HomeViewModel: DatabaseDelegate {
    
    
    func saveSuccess(data: Child) {
        
    }
    
    func taskFailure(databaseError: ErrorType) {
        homeDelegate?.childNotFound()
    }
    
    
    func taskFailure(message: String) {
        Logger.init().error("\(message)")
        homeDelegate?.childNotFound()
    }
    
    func taskSuccess(message: String) {
        print(message)
    }
    
    func retrieveListData(dataList: [Child]) {
        if let child = dataList.first {
            homeDelegate?.childRetrieved(with: child)
        }
    }
    
    func retrieveData(data: Child) {
        print(data)
        homeDelegate?.childRetrieved(with: data)
    }
    
    typealias T = Child
    

    
    var homeDelegate: HomeProtocol?
    var babyService: BabyService?
    func isUserLogged() -> Bool {
        
        let user = Auth.auth().currentUser
        
        return user != nil
        
        
    }
    
    
    func initialize() {
        babyService = BabyService(delegate: self)

        if let user = Auth.auth().currentUser {
            homeDelegate?.authSuccess(user: user)
            fetchChild(uid: user.uid)
        } else {
            homeDelegate?.requireAuth()
        }
    }
    
    private func fetchChild(uid: String) {
        babyService?.getAllData()
    }
}
