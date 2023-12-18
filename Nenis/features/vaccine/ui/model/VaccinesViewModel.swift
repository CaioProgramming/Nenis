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
}
class VaccinesViewModel {
    
    var child: Child? = nil
    var selectedInfo: (Child, Vaccine,Int)? = nil
    var delegate: VaccineProtocol? = nil
    var babyService : BabyService = BabyService()
    
    func selectVaccine(vaccineItem: VaccineItem) {
        if let currentChild = child {
            Logger.init().debug("Selected vaccine => \(vaccineItem.vaccine.description) with \(vaccineItem.vaccine.periods.count) periods, child \(currentChild.name) has taken \(vaccineItem.nextDose)")
            selectedInfo = (currentChild,  vaccineItem.vaccine, vaccineItem.nextDose + 1)
            delegate?.confirmVaccine()
        } else {
            Logger.init().warning("No child setted => \(self.child.debugDescription)")

        }
    }
    
    func loadVaccines(with child: Child) -> [Status : [VaccineItem]] {
        let logger = Logger.init()
        let vaccineHelper = VaccineHelper()
        return vaccineHelper.groupVaccines(with: child)
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

