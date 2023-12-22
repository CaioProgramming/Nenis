//
//  DiaperMapper.swift
//  Nenis
//
//  Created by Caio Ferreira on 07/12/23.
//

import Foundation

struct DiaperItem {
    let diaper: Diaper
    let linkedActions: [Activity]
}

class DiaperMapper {
    func mapDiapers(child: Child) -> [DiaperItem] {
        
       return child.diapers.map({ diaper in
            let actions = child.actions.filter({ action in
            
                action.usedDiaper?.caseInsensitiveCompare(diaper.type) == .orderedSame
                
            })
           return DiaperItem(diaper: diaper, linkedActions: actions)
        })
        
        
    }
}

