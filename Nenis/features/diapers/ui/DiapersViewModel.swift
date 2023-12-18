//
//  DiapersViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 23/11/23.
//

import Foundation
import UIKit


protocol DiaperProtocol {
    
    func retrieveDiapers(diaperItems: [DiaperItem])
    func updateDiaper()
    func diaperUpdated(message: String)
    func errorUpdating(message: String)
    func requestActivity()
}

class DiapersViewModel {
    
    var child: Child? = nil
    private let babyService = BabyService()
    var delegate: DiaperProtocol? = nil
    var selectedDiaper: DiaperItem? = nil
    
    func getDiapers(currentChild: Child?) {
        
        if let selectedChild = currentChild {
            self.child = selectedChild
            let mapper = DiaperMapper()
            let diapers = mapper.mapDiapers(child: selectedChild)
            delegate?.retrieveDiapers(diaperItems: diapers)
        }
     
    }
    
    func selectDiaper(diaper: DiaperItem) {
        selectedDiaper = diaper
        delegate?.updateDiaper()
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
       Task {
          await babyService.updateData(data: newChild,
                                  onSuccess: updateSuccess,
                                  onFailure: { _ in })
       }
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
    
    func updateSuccess(data: Child) {
        delegate?.diaperUpdated(message: "Fraldas atualizadas com sucesso.")
        getDiapers(currentChild: data)
    }
}

