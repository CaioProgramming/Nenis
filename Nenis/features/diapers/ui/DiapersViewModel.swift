//
//  DiapersViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 23/11/23.
//

import Foundation


protocol DiaperProtocol {
    
    func retrieveDiapers(diapers: [Diaper])
    func updateDiaper()
    func diaperUpdated(message: String)
    func errorUpdating(message: String)
    
}

class DiapersViewModel {
    
    var child: Child? = nil
    private var babyService : BabyService? = nil
    var delegate: DiaperProtocol? = nil
    var selectedDiaper: Diaper? = nil
    func getDiapers(currentChild: Child?) {
        if let selectedChild = currentChild {
            self.child = selectedChild
            babyService = BabyService(delegate: self)
            delegate?.retrieveDiapers(diapers: selectedChild.diapers)
        }
     
    }
    
    func selectDiaper(diaper: Diaper) {
        selectedDiaper = diaper
        delegate?.updateDiaper()
    }
    
    func discardDiaper(diaper: Diaper) {
        if var currentChild = child {
            if let selectedDiaper = currentChild.diapers.firstIndex(of: diaper) {
                var newDiaper = diaper
                newDiaper.discarded += 1
                var diapers = currentChild.diapers
                diapers[selectedDiaper] = newDiaper
                currentChild.diapers = diapers
                updateChild(with: currentChild)
            }
        }
    }
    
    func updateDiaper(diaper: Diaper) {
        if var currentChild = child {
           if let selectedDiaper = currentChild.diapers.firstIndex(where: { savedDiaper in
            
               savedDiaper.type == diaper.type
                
           }) {
               currentChild.diapers[selectedDiaper].quantity += diaper.quantity
               updateChild(with: currentChild)
           } 
        } else {
            delegate?.errorUpdating(message: "Error updating, no child founded.")
        }
    }
    
   private func updateChild(with newChild: Child) {
        babyService?.updateData(data: newChild)
    }
    
    func addDiaper(diaper: Diaper) {
        if var currentChild = child {
            
           let childContainsDiaper = currentChild.diapers.contains(where: { childDiaper in
                childDiaper.type == diaper.type
            })
            if(childContainsDiaper) {
                updateDiaper(diaper: diaper)
            } else {
                currentChild.diapers.append(diaper)
                updateChild(with: currentChild)
            }
      
        }
    }
    func deleteDiaper(diaper: Diaper) {
        if var currentChild = child {
            if let diaperIndex = currentChild.diapers.firstIndex(of: diaper) {
                currentChild.diapers.remove(at: diaperIndex)
                updateChild(with: currentChild)
            }
            
        }
    }
    
}

extension DiapersViewModel: DatabaseDelegate {
    
    func retrieveListData(dataList: [Child]) { }
    
    func retrieveData(data: Child) { }
    
    typealias T = Child
    
    func updateSuccess(data: Child) {
        self.child = data
        delegate?.diaperUpdated(message: "Fraldas atualizadas com sucesso.")
        delegate?.retrieveDiapers(diapers: data.diapers)
    }
    
 
    
    
}
