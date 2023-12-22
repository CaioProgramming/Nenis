//
//  VaccineTip.swift
//  Nenis
//
//  Created by Caio Ferreira on 22/12/23.
//

import Foundation
import TipKit


protocol VaccineTipDelegate {
    func addToCalendar()
}
@available(iOS 17.0, *)
struct VaccineTip: Tip {
    var delegate: VaccineTipDelegate
    var id: String = "Vaccine"
    
    var title: Text {
        Text("Save Vaccines")
    }
    
    var message: Text? {
        Text("Add vaccines to calendar to keep in day.")
    }
    
    var asset: Image? {
        Image(systemName: "syringe.fill")
    }
    
    
    var actions: [Action] {
        [Action(id: "save-calendar", title: "Adicionar ao calendário", perform: {
            delegate.addToCalendar()
        })
        ]
    }
}
