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
    func openDiapers()
    func openVaccines()
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
            delegate?.childRetrieved(with: child)
            self.child = child
            buildHomeFromChild(with: child)
        }
    }
    
    func buildChildSection(with child: Child, userName: String) -> ChildSection {
        
        
        return ChildSection(title: "Olá, \(userName)!", subtitle: Date.now.formatted(date: .complete, time: .omitted), items: [child], itemClosure: { child, view in
            
            self.delegate?.openChild(child: child)
            
            
        }, footerData: nil)
    }
    
    
    
    func retrieveData(data: Child) {
        print(data)
        child = data
        delegate?.childRetrieved(with: data)
        buildHomeFromChild(with: data)
    
    }
    
    
    func taskFailure(databaseError: ErrorType) {
        delegate?.childNotFound()
    }
    
    //MARK: - Vaccine Tasks
    
    func buildVaccineSection(with child: Child) -> VaccineSection {
        let vaccineHelper = VaccineHelper()
   
        let vaccines = vaccineHelper.filterVaccineStatus(with: child, status: Status.soon).prefix(6)
        
        let vaccinesTitle =  String(localized: "NextVaccines", table: "Localizable")
        let headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)? = ("Próximas vacinas", "Ver mais", UIImage(systemName: "chevron.right"), { view in
            self.delegate?.openVaccines()
        })
        return VaccineSection(items: Array(vaccines), itemClosure: { vaccine, view in
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
            delegate?.confirmVaccine()
        }
    }
    
    //MARK: - Action Tasks
    
    func buildActionSection(with child: Child) -> ActionSection {
        let actionsTitle = String.localizedStringWithFormat(NSLocalizedString("ActivitiesTitle", comment: ""), child.name)

        var footerData: (message:String, actionTitle: String, closure: (UIView?) -> Void)? = if(child.actions.isEmpty) {
            ("\(child.name) nao possui atividades, adicione algumas para acompanha-lo.", "Adicionar atividades", { view in
                self.delegate?.requestNewAction()
            })
        } else { nil }
        var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)? = if(child.actions.isEmpty) {  nil } else {

            (actionsTitle, "", UIImage(systemName: "plus.circle.fill"), { view in
                self.delegate?.requestNewAction()
            })
        }
        return ActionSection(items: child.actions.sortByDate(), itemClosure: { action, view in }, headerData: headerData, footerData: footerData)
    }
    
    func addNewAction(action: Action) {
        if var currentChild = child {
            currentChild.actions.append(action)
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
    

    func updateDiaper(with diaper: Diaper, index: Int) {
        if var currentChild = child {
            currentChild.diapers[index] = diaper
            babyService?.updateData(data: currentChild)
        }
    }
    
    func buildChildDiapers(with child: Child) -> DiaperHomeSection {
        let headerData : (String, String, UIImage?, (UIView?) -> Void)? = ("Fraldas", "Ver todas", UIImage(systemName: "chevron.right"), { view in
            self.delegate?.openDiapers()
        })
        let footerData: (String, String, (UIView?) -> Void)? = if(!child.diapers.isEmpty) { nil } else {
            ("\(child.name) nao possui fraldas salvas, adicione algumas para acompanhar.", "Adicionar Fraldas", { _ in
                self.delegate?.openDiapers()
            })
        }
        let diaperHelper = DiaperMapper()
        let diaperItems = diaperHelper.mapDiapers(child: child)
        return DiaperHomeSection(items: diaperItems, itemClosure: { diaper, view in
            self.delegate?.openDiapers()
        }, headerData: headerData, footerData: footerData)
    }
    
    

    //MARK: ViewModelSetup

  
    typealias T = Child
    var delegate: HomeProtocol?
    private var babyService: BabyService?
    
    func isUserLogged() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    func initialize() {
        babyService = BabyService(delegate: self)

        if let user = Auth.auth().currentUser {
            delegate?.authSuccess(user: user)
            fetchChild(uid: user.uid)
        } else {
            delegate?.requireAuth()
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
        delegate?.retrieveHome(with: sections)
    }
    

}






