//
//  Diaper.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/11/23.
//

import Foundation
import UIKit

public struct Diaper: Codable, Equatable {
    
    let type: String
    var quantity: Int
    var discarded: Int = 0

}

extension Diaper {
    func getSizeType() -> SizeType? {
        let cases = SizeType.allCases
        print("querying size => \(self.type)")
        return cases.first(where: { element in
            return element.description.caseInsensitiveCompare(self.type) == .orderedSame
      })
    }
}

enum SizeType: CaseIterable {
    case RN, P, M, G, GG, XG, XXG
    
    var description: String { get { return "\(self)".uppercased() } }
    
    var color: UIColor {
        get {
           return switch self {
            case .RN:
                #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            case .P:
               #colorLiteral(red: 0.5190970898, green: 0.4923879504, blue: 0.8356563449, alpha: 1)
            case .M:
                #colorLiteral(red: 0.4694516659, green: 0.6432950497, blue: 0.8355560303, alpha: 1)
            case .G:
               #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
            case .GG:
               #colorLiteral(red: 0.8387268186, green: 0.6485952735, blue: 0.4728306532, alpha: 1)
           case .XG:
               #colorLiteral(red: 0.8414876461, green: 0.4845798016, blue: 0.4731430411, alpha: 1)
            case .XXG:
               #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
            }
        }
    }

}

extension String {
    func getDiaperSizeByDescription() -> SizeType? {
        let cases = SizeType.allCases
        print("querying size => \(self)")
        return cases.first(where: { element in
            return element.description.caseInsensitiveCompare(self) == .orderedSame
      })
    }
}
