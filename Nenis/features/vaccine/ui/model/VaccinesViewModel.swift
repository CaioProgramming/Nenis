//
//  VaccinesViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import Foundation
import os

protocol VaccineProtocol {
    func confirmVaccine()
    func updateData()
    func showMessage(message: String)
}
class VaccinesViewModel {
    
    var child: Child? = nil
    var selectedInfo: (Child, VaccineItem)? = nil
    var delegate: VaccineProtocol? = nil
    var babyService : BabyService = BabyService()
    
    func selectVaccine(vaccineItem: VaccineItem) {
        if let currentChild = child {
            Logger.init().debug("Selected vaccine => \(vaccineItem.vaccine.description) with \(vaccineItem.vaccine.periods.count) periods, child \(currentChild.name) has taken \(vaccineItem.nextDose)")
            selectedInfo = (currentChild,  vaccineItem)
            delegate?.confirmVaccine()
        } else {
            Logger.init().warning("No child setted => \(self.child.debugDescription)")
            
        }
    }
    
    func addVaccineToCalendar(vaccineItem: VaccineItem, showMessage: Bool = true) {
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
                        if(showMessage) {
                            self.delegate?.showMessage(message: "\(title) adicionada ao calendário.")
                        }
                        
                    },
                    onFailure: {})
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    func addAllVacinesToCalendar(vaccines: [VaccineItem]) {
        vaccines.forEach({ item in
            
            addVaccineToCalendar(vaccineItem: item, showMessage: false)
            if(item == vaccines.last) {
                delegate?.showMessage(message: "Vacinas adicionadas ao calendário")
            }
            
        })
    }
    
    func loadVaccines(with child: Child) -> [(key: Status , value: [VaccineItem])] {
        let vaccineHelper = VaccineHelper()
        return vaccineHelper.groupVaccines(with: child).sorted(by: { firstItem, lastItem in
            
            return firstItem.key == .done
            
        })
    }
    
    func updateVaccine(newVaccine: Vaccination) {
        if var currentChild = child {
            let vaccineIndex = currentChild.vaccines.firstIndex(where: { item in
                
                item.vaccine.caseInsensitiveCompare(newVaccine.vaccine.description) == .orderedSame
            })
            if(vaccineIndex == nil){
                currentChild.vaccines.append(newVaccine)
            } else {
                currentChild.vaccines[vaccineIndex!] = newVaccine
            }
            updateChild(newChild: currentChild)
        }
    }
    
    func updateChild(newChild: Child) {
        Task {
            await  babyService.updateData(data: newChild,
                                          onSuccess: updateSuccess,
                                          onFailure: { _ in }
            )
        }
    }
    
    func updateSuccess(data: Child) {
        self.child = data
        delegate?.updateData()
    }
}

