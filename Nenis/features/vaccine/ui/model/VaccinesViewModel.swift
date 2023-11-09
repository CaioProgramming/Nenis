//
//  VaccinesViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/11/23.
//

import Foundation

protocol VaccineProtocol {
    func confirmVaccine()
}
class VaccinesViewModel {
    
    var child: Child? = nil
    var selectedInfo: (Child, Vaccine,Int)? = nil
    var delegate: VaccineProtocol? = nil
    func selectVaccine(vaccineItem: VaccineItem) {
        if let currentChild = child {
            selectedInfo = (currentChild,  vaccineItem.vaccine, vaccineItem.nextDose)
            delegate?.confirmVaccine()
        }
    }
    
    func loadVaccines(with child: Child) -> [VaccineItem] {
        let vaccineHelper = VaccineHelper()
        self.child = child
       return Vaccine.allCases.map({ vaccine in
           return vaccineHelper.getVaccineItem(with: child, vaccine: vaccine)
        })
    }
}
