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
    var vaccineUpdateInfo : (Child, Vaccine, Int)? = nil
    
    func updateSuccess(data: Child) {
        child = data
        buildHomeFromChild(with: data)
    }
    
    func updateChildVaccine(vaccinate: Vaccination) {
        if var currentChild = child {
            let vaccineIndex = currentChild.vaccines.firstIndex(where: { item in
                
                item.vaccine.description.caseInsensitiveCompare(vaccinate.vaccine) == .orderedSame
            })
            if(vaccineIndex == nil){
                currentChild.vaccines.append(vaccinate)
            } else {
                currentChild.vaccines[vaccineIndex!] = vaccinate
            }
            babyService?.updateData(id: currentChild.id, data: currentChild)
        }
    }
    
    func selectVaccine(vaccineItem: VaccineItem) {
        if let currentChild = child {
            vaccineUpdateInfo = (currentChild, vaccineItem.vaccine, vaccineItem.nextDose)
        }
    }
    
    func addNewAction(action: Action) {
        if var currentChild = child {
            currentChild.actions.append(action)
            babyService?.updateData(id: currentChild.id, data: currentChild)
        }
    }
    
    
    func deleteAction(actionIndex: Int) {
        if var currentChild = child {
            currentChild.actions.remove(at: actionIndex)
            babyService?.updateData(id: currentChild.id, data: currentChild)
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
    
    func buildChildSection(with child: Child, userName: String) -> ChildSection {
        return ChildSection(items: [child], type: .child,  title: "Olá, \(userName)!", subtitle: Date.now.formatted(date: .complete, time: .omitted))
    }
    
    func buildHomeFromChild(with child: Child) {
        
        let actionsTitle = String.localizedStringWithFormat(NSLocalizedString("ActivitiesTitle", comment: ""), child.name)
        let userName = babyService?.currentUser()?.displayName ?? ""
        let sections: [any Section] = [
            buildChildSection(with: child, userName: userName),
            buildVaccineSection(with: child),
            ActionSection(items: child.actions.sortByDate(), type: .actions, title: actionsTitle)
        ]
        Logger().info("Home sections -> \(sections.debugDescription)")
        homeDelegate?.retrieveHome(with: sections)
    }
    
    func buildVaccineSection(with child: Child) -> VaccineSection {
        let vaccineHelper = VaccineHelper()
   
        let vaccines = vaccineHelper.filterVaccineStatus(with: child, status: Status.soon)
        
        let vaccinesTitle =  String(localized: "NextVaccines", table: "Localizable")
        return VaccineSection(items: vaccines, type: .vaccines, title: vaccinesTitle)
        
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

extension Date {
    func addMonth(month: Int) -> Date? {

        let calendar = NSCalendar.current
        return calendar.date(byAdding: .month, value: month, to: self)
    }
}


