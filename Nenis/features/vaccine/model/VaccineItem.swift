//
//  VaccineItem.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import Foundation
import UIKit

struct VaccineItem: Equatable {
    let vaccine: Vaccine
    let nextDate: Date
    let doseProgress: Float
    let status: Status
    let nextDose: Int
}

extension VaccineItem {
    func formatNextDate() -> String {
        return nextDate.formatted(date: .abbreviated, time: .omitted) 
    }
}

enum Status {
    case  done, soon, late
    
    var description: String { get { return "\(self)".uppercased() } }

    var title: String {
        get {
            switch self {
                
            case .late:
                "Vacinas atrasadas"
            case .done:
                "Vacinas concluídas"
            case .soon:
                "Próximas vacinas"
            }
        }
    }
    
    var color: UIColor {
        get {
            switch self {
            case .late:
                #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            case .done:
                #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            case .soon:
                #colorLiteral(red: 0.2388284206, green: 0.6591930389, blue: 0.664681673, alpha: 1)
            }
        }
    }
    
    var icon: UIImage? {
        get {
            switch self {
            case .done:
                UIImage(systemName: "checkmark.shield.fill")
            case .soon:
                UIImage(systemName: "clock.circle")
            case .late:
                UIImage(systemName: "exclamationmark.triangle.fill")
            }
        }
    }
}
