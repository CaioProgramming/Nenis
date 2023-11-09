//
//  VaccineItem.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import Foundation
import UIKit

struct VaccineItem {
    let vaccine: Vaccine
    let nextDate: String
    let doseProgress: Float
    let status: Status
    let nextDose: Int
}

enum Status {
    case late, done, soon
    
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
}
