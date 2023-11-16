//
//  Child.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/09/23.
//

import Foundation
import FirebaseFirestoreSwift
import UIKit
import os

public struct Child: Codable {
    @DocumentID var id: String?
    let name: String
    let birthDate: Date
    let photo: String
    var gender: String
    var tutors: [String]
    var actions: [Action]
    var vaccines: [Vaccination]
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case photo
        case gender
        case tutors
        case actions
        case vaccines
    }
}

struct Vaccination: Codable {
    let vaccine: String
    let dose: Int
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
            return element.description.caseInsensitiveCompare(self) == .orderedSame
      })
    }
}
extension Child {
    
    func getAge() -> String {
        let calendar = NSCalendar.current
        let birth = self.birthDate
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
        
        Logger.init().info("Data diff -> \(components.debugDescription)")
        let year = components.year ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0
        
        var ageFormatted = ""
        
        if(year > 0) {
            ageFormatted += "\(year) ano"
            if(year > 1) {
                ageFormatted += "s"
            }
        }
        
        if(weeks > 0) {
            ageFormatted += " \(weeks) semana"
            if(weeks > 1) {
                ageFormatted += "s"
            }
        }
        
        if(days > 0) {
            ageFormatted += " \(days) dia"
            if(days > 1) {
                ageFormatted += "s"
            }
        }
            
        
        return ageFormatted
    }
    
}
