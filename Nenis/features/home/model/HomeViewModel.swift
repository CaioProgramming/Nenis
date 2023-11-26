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
    func requestNewAction()
}




class HomeViewModel: DatabaseDelegate {
    
    var child: Child? = nil
    var vaccineUpdateInfo : (Child, Vaccine, Int)? = nil
    
    
    //MARK: Child tasks
    
    private func fetchChild(uid: String) {
        babyService?.queryData(field: "tutors", value: uid, isArray: true)
    }
    
    func updateSuccess(data: Child) {
        child = data
        buildHomeFromChild(with: data)
    }
    
    func retrieveListData(dataList: [Child]) {
        if let child = dataList.first {
            homeDelegate?.childRetrieved(with: child)
            self.child = child
            buildHomeFromChild(with: child)
        }
    }
    
    func buildChildSection(with child: Child, userName: String) -> ChildSection {
        return ChildSection(items: [child], title: "Olá, \(userName)!", subtitle: Date.now.formatted(date: .complete, time: .omitted))
    }
    
    
    
    func retrieveData(data: Child) {
        print(data)
        child = data
        homeDelegate?.childRetrieved(with: data)
        buildHomeFromChild(with: data)
    
    }
    
    
    func taskFailure(databaseError: ErrorType) {
        homeDelegate?.childNotFound()
    }
    
    //MARK: - Vaccine Tasks
    
    func buildVaccineSection(with child: Child) -> VaccineSection {
        let vaccineHelper = VaccineHelper()
   
        let vaccines = vaccineHelper.filterVaccineStatus(with: child, status: Status.soon).prefix(6)
        
        let vaccinesTitle =  String(localized: "NextVaccines", table: "Localizable")
        return VaccineSection(items: Array(vaccines),title: vaccinesTitle, itemClosure: { vaccine in
            self.selectVaccine(vaccineItem: vaccine)
        }, headerClosure: { section in
            self.sectionDelegate?.openVaccines()
        })
        
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
            babyService?.updateData( data: currentChild)
        }
    }
    
    func selectVaccine(vaccineItem: VaccineItem) {
        if let currentChild = child {
            vaccineUpdateInfo = (currentChild, vaccineItem.vaccine, vaccineItem.nextDose)
        }
    }
    
    //MARK: - Action Tasks
    
    func addNewAction(action: Action, diaperSize: SizeType) {
        if var currentChild = child {
            currentChild.actions.append(action)
            if(action.type.getAction() == .bath) {
               var diapers = currentChild.diapers
               if var sizeDiaper = diapers.first(where: { diaper in
                    diaper.type == diaperSize.description
               }) {
                   if let index = diapers.firstIndex(of: sizeDiaper) {
                       sizeDiaper.discarded += 1
                       diapers[index] = sizeDiaper
                       currentChild.diapers = diapers
                   }
               }
            }
            babyService?.updateData(data: currentChild)
        }
    }
    
    
    func deleteAction(actionIndex: Int) {
        if var currentChild = child {
            currentChild.actions.remove(at: actionIndex)
            babyService?.updateData(data: currentChild)
        }
    }
    
    
    //MARK: - Diapers Tasks
    
    func addDiaper(with diaper: Diaper) {
        if var currentChild = child {
            currentChild.diapers.append(diaper)
            babyService?.updateData(data: currentChild)
        }
    }

    func deleteDiaper(with diaperIndex: Int) {
        if var currentChild = child {
             
            currentChild.diapers.remove(at: diaperIndex)
            babyService?.updateData(data: currentChild)
        }
    }
    
    func updateDiaper(with diaper: Diaper, index: Int) {
        if var currentChild = child {
            currentChild.diapers[index] = diaper
            babyService?.updateData(data: currentChild)
        }
    }
    
    func buildChildDiapers(with child: Child) -> DiaperSection {
        let diapers = SizeType.allCases.map({ size in
            let randomQuantity = Int.random(in: 50..<100)
            let randomDiscard = Int.random(in: (randomQuantity/2)..<randomQuantity - 10)
            let diaper = Diaper(type: size.description, quantity: randomQuantity, discarded: randomDiscard)
            print("building random diaper => \(String(describing: diaper))")

            return Diaper(type: size.description, quantity: randomQuantity, discarded: randomDiscard)
        })
        return DiaperSection(title: "Fraldas", items: child.diapers, headerClosure: { section in
            self.sectionDelegate?.openDiapers()
        })
    }
    
    

    //MARK: ViewModelSetup

  
    typealias T = Child
    var homeDelegate: HomeProtocol?
    var sectionDelegate: SectionsProtocol?
    var babyService: BabyService?
    
    func isUserLogged() -> Bool {
        return Auth.auth().currentUser != nil
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
    
    func buildHomeFromChild(with child: Child) {
        
        let actionsTitle = String.localizedStringWithFormat(NSLocalizedString("ActivitiesTitle", comment: ""), child.name)
        let userName = babyService?.currentUser()?.displayName ?? ""
        let sections: [any Section] = [
            buildChildSection(with: child, userName: userName),
            buildChildDiapers(with: child),
            buildVaccineSection(with: child),
            ActionSection(items: child.actions.sortByDate(), title: actionsTitle, headerClosure: { section in
                self.homeDelegate?.requestNewAction()
            })
        ]
        Logger().info("Home sections -> \(sections.debugDescription)")
        homeDelegate?.retrieveHome(with: sections)
    }
    

}






