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
import EventKit

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
    func showMessage(message: String)
}




class HomeViewModel {
    
    private var babyService = BabyService()
    var child: Child? = nil
    var vaccineUpdateInfo : (Child, VaccineItem)? = nil
    
    
    //MARK: Child tasks
    
    private func childUpdated(newChild: Child) {
        DispatchQueue.main.async {
            self.child = newChild
            self.buildHomeFromChild(with: newChild)
        }
        
    }
    
    func fetchChild(uid: String) {
        Task {
            await babyService
                .queryData(
                    field: "tutors",
                    value: uid,
                    isArray: true,
                    onSuccess: { childs in
                        if let actualChild = childs.first {
                            childUpdated(newChild: actualChild)
                            delegate?.childRetrieved(with: actualChild)
                        }
                    },
                    onFailure: { error in
                        delegate?.childNotFound()
                    }
                )
        }
    }
    
    func updateChild(newChild: Child) {
        Task {
            await babyService
                .updateData(
                    data: newChild,
                    onSuccess: { newData in
                        childUpdated(newChild: newData)
                    },
                    onFailure: { error in
                        
                    }
                )
        }
    }
    
    
    func buildChildSection(with child: Child, userName: String) -> ChildSection {
        return ChildSection( title: "Olá, \(userName)!", subtitle: Date.now.formatted(date: .complete, time: .omitted), items: [child],
                             itemClosure: { child, _ in  self.delegate?.openChild(child: child) })
    }
    
    //MARK: - Vaccine Tasks
    
    func buildVaccineSection(with child: Child) -> VaccineSection {
        let vaccineHelper = VaccineHelper()
        
        let vaccines = vaccineHelper.filterVaccineStatus(with: child, status: Status.soon).prefix(4)
        
        let vaccinesTitle =  String(localized: "NextVaccines", table: "Localizable")
        let headerData = HeaderComponent(
            title: vaccinesTitle,
            actionLabel: "Ver mais",
            actionIcon: IconConfiguration(image: UIImage(systemName: "chevron.right")),
            trailingIcon: nil,
            actionClosure: { _ in self.delegate?.openVaccines() })
        
        return VaccineSection(items: Array(vaccines),
                              itemClosure: { vaccine, view in
                                    self.selectVaccine(vaccineItem: vaccine)
                                },
                              eventRequest: addVaccineToCalendar,
                              headerData: headerData)
        
    }
    
    func addVaccineToCalendar(vaccineItem: VaccineItem) {
        if let currentChild = child {
            let eventService = EventService()
            let title = "Vacina \(vaccineItem.vaccine.title)"
            let note = "\(vaccineItem.nextDose + 1)º dose de \(vaccineItem.vaccine.title) para o \(currentChild.name)"
            if #available(iOS 17.0, *) {
                eventService.addEvent(
                    identifier: vaccineItem.vaccine.description,
                    title: title,
                                      note: note,
                                      date: vaccineItem.nextDate,
                                      onSuccess: {
                    
                        self.delegate?.showMessage(message: "\(title) adicionada ao calendário.")
                    
                },
               onFailure: {
                   
                   self.delegate?.showMessage(message: "Ocorreu um erro ao adicionar ao calendário.")
               })
            } else {
                // Fallback on earlier versions
            }
        }
        
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
            updateChild(newChild: currentChild)
        }
    }
    
    func selectVaccine(vaccineItem: VaccineItem) {
        if let currentChild = child {
            vaccineUpdateInfo = (currentChild, vaccineItem)
            delegate?.confirmVaccine()
        }
    }
    
    //MARK: - Action Tasks
    
    func buildActionSection(with child: Child) -> ActionSection {
        let actionsTitle = String.localizedStringWithFormat(NSLocalizedString("ActivitiesTitle", comment: ""), child.name)
        
        let footerData: FooterComponent? = if(child.actions.isEmpty) {
            FooterComponent(
                message: "\(child.name) nao possui atividades, adicione algumas para acompanha-lo.",
                actionLabel: "Adicionar atividades",
                messageIcon: nil,
                actionClosure: { _ in self.delegate?.requestNewAction() }
            )
            
        } else { nil }
        let headerData: HeaderComponent? = if(child.actions.isEmpty) {  nil } else {
            
            HeaderComponent(
                title: actionsTitle,
                actionLabel: nil,
                actionIcon: IconConfiguration(image: UIImage(systemName: "plus.circle.fill")),
                trailingIcon: nil,
                actionClosure: { _ in self.delegate?.requestNewAction() })
            
        }
        return ActionSection(items: child.actions.sortByDate(), itemClosure: { action, view in } , headerData:  headerData, footerData: footerData, editingStyle: .delete )
    }
    
    func addNewAction(action: Activity) {
        if var currentChild = child {
            var newAction = action
            if(action.type.getAction() != .bath) {
                newAction.usedDiaper = nil
            }
            currentChild.actions.append(newAction)
            updateChild(newChild: currentChild)
        }
    }
    
    
    func deleteAction(actionIndex: Int) {
        if let currentChild = child {
            var newChild = currentChild
            newChild.actions.remove(at: actionIndex)
            updateChild(newChild: currentChild)
        }
    }
    
    
    //MARK: - Diapers Tasks
    
    func addDiaper(with diaper: Diaper) {
        if var currentChild = child {
            currentChild.diapers.append(diaper)
            updateChild(newChild: currentChild)
        }
    }
    
    func deleteDiaper(with diaper: Diaper) {
        if var currentChild = child {
            if let diaperIndex = currentChild.diapers.firstIndex(of: diaper) {
                currentChild.diapers.remove(at: diaperIndex)
                updateChild(newChild: currentChild)
            }
            
        }
    }
    
    
    func updateDiaper(with diaper: Diaper, index: Int) {
        if var currentChild = child {
            currentChild.diapers[index] = diaper
            updateChild(newChild: currentChild)
        }
    }
    
    func buildChildDiapers(with child: Child) -> DiaperHomeSection {
        let headerData : HeaderComponent? = HeaderComponent(
            title: "Fraldas",
            actionLabel: "Ver todas",
            actionIcon: IconConfiguration(image: UIImage(systemName: "chevron.right")),
            trailingIcon: nil,
            actionClosure: { view in self.delegate?.openDiapers() })
        
        let footerData: FooterComponent? = if(!child.diapers.isEmpty) { nil } else {
            FooterComponent(
                message: "\(child.name) nao possui fraldas salvas, adicione algumas para acompanhar.",
                actionLabel: "Adicionar Fraldas",
                messageIcon: nil,
                actionClosure: { _ in  self.delegate?.openDiapers() }
            )
            
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
    
    func isUserLogged() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    
    func initialize() {
        babyService = BabyService()
        
        if let user = Auth.auth().currentUser {
            delegate?.authSuccess(user: user)
            let userHelper = UserHelper()
            userHelper.updateUser(user: user)
            
            fetchChild(uid: user.uid)
        } else {
            delegate?.requireAuth()
        }
    }
    
    
    func buildHomeFromChild(with child: Child) {
        
        let userName = babyService.currentUser()?.displayName ?? ""
        let sections: [any Section] = [
            buildChildSection(with: child, userName: userName),
            buildChildDiapers(with: child),
            buildVaccineSection(with: child),
            buildActionSection(with: child)
        ]
        delegate?.retrieveHome(with: sections)
    }
    
    
}





