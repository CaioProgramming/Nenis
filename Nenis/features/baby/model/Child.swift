//
//  Child.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/09/23.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit

public struct Child: Codable {
    @DocumentID var id: String?
    let name: String
    let birthDate: Date
    let photo: String
    var gender: String
    var tutors: [String]
    var actions: [Action]
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case photo
        case gender
        case tutors
        case actions
    }
}

enum Gender : Codable, CaseIterable {
    
    case boy, girl
    
    var description: String { get { return "\(self)".uppercased() } }

    
    var color: UIColor {
        get {
            switch self {
                
            case .boy:
                #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            case .girl:
                #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            }
        }
    }
}

extension String {
    func getGender() -> Gender? {
        let cases = Gender.allCases
        return cases.first(where: { element in
            print("querying gender -> \(self)")
            return element.description.caseInsensitiveCompare(self) == .orderedSame
      })
    }
}
