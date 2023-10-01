//
//  InviteViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 01/10/23.
//

import Foundation

protocol InviteDelegate {
    func childRetrieved(child: Child)
    func childNotFound()
    func childUpdated()
}

class InviteViewModel: DatabaseDelegate {
    
    var delegate: InviteDelegate? = nil
    
    func retrieveListData(dataList: [Child]) {
        
    }
    
    func retrieveData(data: Child) {
        delegate?.childRetrieved(child: data)
    }
    
    func saveSuccess(data: Child) {
        delegate?.childUpdated()
    }
    
    func taskFailure(databaseError: ErrorType) {
        delegate?.childUpdated()
    }
    
    func taskSuccess(message: String) {
        
    }
    
    typealias T = Child
    
    
    var babyService : BabyService? = nil
    
    init() {
        self.babyService = BabyService(delegate: self)
    }
    
    func useInvite(inviteID: String) {
        babyService?.getSingleData(id: inviteID)
    }
    
}
