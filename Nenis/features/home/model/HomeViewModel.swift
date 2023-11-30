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
import UIKit

protocol HomeProtocol {
    
    func retrieveHome(with homeSection: [any Section])
    func childRetrieved(with child: Child)
    func openChild(child: Child)
    func childNotFound()
    func requireAuth()
    func authSuccess(user: User)
    func requestNewAction()
    func confirmVaccine()
}




class HomeViewModel: DatabaseDelegate {
    
    var child: Child? = nil
    var vaccineUpdateInfo : (Child, Vaccine, Int)? = nil
    
    
    //MARK: Child tasks
    
    private func fetchChild(uid: String) {
        babyService?.queryData(field: "tutors", value: uid, isArray: true)
    }
    
    func updateSuccess(data: Child) {
        self.child = data
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
        
        
        return ChildSection(title: "Olá, \(userName)!", subtitle: Date.now.formatted(date: .complete, time: .omitted), items: [child], itemClosure: { child in
            
            self.homeDelegate?.openChild(child: child)
            
            
        }, footerData: nil)
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
        let headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)? = ("Próximas vacinas", "Ver mais", nil, {
            self.sectionDelegate?.openVaccines()
        })
        return VaccineSection(items: Array(vaccines), itemClosure: { vaccine in
            self.selectVaccine(vaccineItem: vaccine)
        }, headerData: headerData)
        
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
            vaccineUpdateInfo = (currentChild, vaccineItem.vaccine, vaccineItem.nextDose + 1)
            homeDelegate?.confirmVaccine()
        }
    }
    
    //MARK: - Action Tasks
    
    func buildActionSection(with child: Child) -> ActionSection {
        let actionsTitle = String.localizedStringWithFormat(NSLocalizedString("ActivitiesTitle", comment: ""), child.name)

        var footerData: (message:String, actionTitle: String, closure: () -> Void)? = if(child.actions.isEmpty) {
            ("\(child.name) nao possui atividades, adicione algumas para acompanha-lo.", "Adicionar atividades", {
                self.homeDelegate?.requestNewAction()
            })
        } else { nil }
        var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)? = if(child.actions.isEmpty) {  nil } else {

            (actionsTitle, "", UIImage(systemName: "plus.circle.fill"), {
                self.homeDelegate?.requestNewAction()
            })
        }
        return ActionSection(items: child.actions.sortByDate(), itemClosure: { action in }, headerData: headerData, footerData: footerData)
    }
    
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

    func deleteDiaper(with diaper: Diaper) {
        if var currentChild = child {
            if let diaperIndex = currentChild.diapers.firstIndex(of: diaper) {
                currentChild.diapers.remove(at: diaperIndex)
                babyService?.updateData(data: currentChild)
            }
            
        }
    }
    
    func discardDiaper(with diaper: Diaper) {
        if var currentChild = child {
            if let diaperIndex = currentChild.diapers.firstIndex(of: diaper) {
                var newDiaper = diaper
                newDiaper.discarded += 1
                var diapers = currentChild.diapers
                diapers[diaperIndex] = newDiaper
                currentChild.diapers = diapers
                babyService?.updateData(data: currentChild)
            }
            
        }
    }
    
    
    
    func updateDiaper(with diaper: Diaper, index: Int) {
        if var currentChild = child {
            currentChild.diapers[index] = diaper
            babyService?.updateData(data: currentChild)
        }
    }
    
    func buildChildDiapers(with child: Child) -> DiaperSection {
        let headerData : (String, String, UIImage?, () -> Void)? = ("Fraldas", "Ver todas", UIImage(systemName: "chevron.right"), {
            self.sectionDelegate?.openDiapers()
        })
        let footerData: (String, String, () -> Void)? = if(!child.diapers.isEmpty) { nil } else {
            ("\(child.name) nao possui fraldas salvas, adicione algumas para acompanhar.", "Adicionar Fraldas", {
                self.sectionDelegate?.openDiapers()
            })
        }
        return DiaperSection(items: child.diapers, itemClosure: { diaper in
            self.sectionDelegate?.openDiapers()
        }, headerData: headerData, footerData: footerData)
    }
    
    

    //MARK: ViewModelSetup

  
    typealias T = Child
    var homeDelegate: HomeProtocol?
    var sectionDelegate: SectionsProtocol?
    private var babyService: BabyService?
    
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
        
        let userName = babyService?.currentUser()?.displayName ?? ""
        let sections: [any Section] = [
            buildChildSection(with: child, userName: userName),
            buildChildDiapers(with: child),
            buildVaccineSection(with: child),
            buildActionSection(with: child)
        ]
        Logger().info("Home sections -> \(sections.debugDescription)")
        homeDelegate?.retrieveHome(with: sections)
    }
    

}






