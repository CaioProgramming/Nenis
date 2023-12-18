//
//  InviteViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 01/10/23.
//

import Foundation
import FirebaseAuth
import os

protocol InviteProtcol {
    func childRetrieved(child: Child)
    func childNotFound()
    func childUpdated(child: Child)
}

class InviteViewModel {
    var delegate: InviteProtcol? = nil

    func saveSuccess(data: Child) {
        delegate?.childUpdated(child: data)
    }
    
    
    func updateSuccess(data: Child) {
        delegate?.childUpdated(child: data)
    }
    
    
    
    func currentUser() -> User? {
        return Auth.auth().currentUser
    }
    
    func retrieveListData(dataList: [Child]) {
        
    }
    
    func retrieveData(data: Child) {
        delegate?.childRetrieved(child: data)
    }
    
    
    func taskFailure(databaseError: ErrorType) {
        Logger.init().critical("\(databaseError.description)")
        delegate?.childNotFound()

    }
    
    func taskSuccess(message: String) {
        Logger.init().debug("\(message)")
    }
    
    typealias T = Child
    
    
    var babyService = BabyService()
    

    
    func useInvite(inviteID: String) {
        Task {
            await babyService.getSingleData(id: inviteID, onSuccess: { data in
            
                delegate?.childRetrieved(child: data)
                
            }, onFailure: { _ in delegate?.childNotFound() } )

        }
    }
    
    func addTutorToChild(with child: Child) {
        if let user = currentUser() {
           
            Task {
                var updatedChild = child
                updatedChild.tutors.append(user.uid)
                await babyService
                    .updateData(data: updatedChild,
                                onSuccess: updateSuccess,
                                onFailure: { _ in }
                    )

            }
        }
    }
    
}
