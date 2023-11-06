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
    
    func retrieveHome(with homeSection: [any Section])
    func childRetrieved(with child: Child)
    func childNotFound()
    func requireAuth()
    func authSuccess(user: User)
}


class HomeViewModel: DatabaseDelegate {
    
    var child: Child? = nil
    
    func updateSuccess(data: Child) {
    
    }
    
    func addNewAction(action: Action) {
        if var currentChild = child {
            currentChild.actions.append(action)
            babyService?.updateData(id: child?.id, data: currentChild)
        }
    }
    
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
            self.child = child
            buildHomeFromChild(with: child)
        }
    }
    
    
    func buildHomeFromChild(with child: Child) {
        let vaccines = Vaccine.allCases.prefix(4).map({ item in
            item.title
        })
        let sections: [any Section] = [
            VaccineSection(items: vaccines, type: .vaccines, title: "Próximas vacinas"),
            ActionSection(items: child.actions.sortByDate(), type: .actions, title: "Atividades de \(child.name)")
        ]
        Logger().info("Home sections -> \(sections.debugDescription)")
        homeDelegate?.retrieveHome(with: sections)
    }
    
    func retrieveData(data: Child) {
        print(data)
        child = data
        homeDelegate?.childRetrieved(with: data)
        buildHomeFromChild(with: data)
    
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
        babyService?.queryData(field: "tutors", value: uid, isArray: true)
    }
}

extension [Action] {
    func sortByDate() -> [ Action] {
        return sorted(by: { firstData, secondData in
            firstData.time.compare(secondData.time) == .orderedDescending
        })
    }
}


