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

class InviteViewModel: DatabaseDelegate {
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
    
    
    var babyService : BabyService? = nil
    
    init() {
        self.babyService = BabyService(delegate: self)
    }
    
    func useInvite(inviteID: String) {
        babyService?.getSingleData(id: inviteID)
    }
    
    func addTutorToChild(with child: Child) {
        if let user = currentUser() {
            var updatedChild = child
            updatedChild.tutors.append(user.uid)
            babyService?.updateData(id: child.id, data: updatedChild)
        }
    }
    
}
