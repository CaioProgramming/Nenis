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
    var id: String?
    let name: String
    let birthDate: Date
    let photo: String
    let gender: String
    var tutors: [String]
    var actions: [Action] = []
    var vaccines: [Vaccination] = []
    var diapers: [Diaper] = []
    
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case photo
        case gender
        case tutors
        case actions
        case vaccines
        case diapers
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
    
    func getSpacers(year: Int, months: Int, weeks: Int, days: Int) -> (String, String, String, String) {
        
        var yearSpace = ""
        var monthSpace = ""
        var weekSpace = ""
        var daySpace = ""
        
        if(months > 0) {
            yearSpace = ", "
        }
        
        if(weeks > 0) {
            monthSpace = ", "
        }
        
        if(days > 0) {
            weekSpace = " e "
            
        }
        
        daySpace = "."
        
        return (yearSpace, monthSpace, weekSpace, daySpace)
        
    }
    
    func getFullAge() -> String {
        let calendar = NSCalendar.current
        let birth = self.birthDate
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
        
        Logger.init().info("Data diff -> \(components.debugDescription)")
        let year = components.year ?? 0
        let months = components.month ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0
        
        var ageFormatted = ""
        let spaces = getSpacers(year: year, months: months, weeks: weeks, days: days)
        
        ageFormatted += addField(count: year, description: "ano", withSpace: spaces.0)
        ageFormatted += addField(count: months, description: "mes", withSpace: spaces.1)
        ageFormatted += addField(count: weeks, description: "semana", withSpace: spaces.2)
        ageFormatted += addField(count: days, description: "dia", withSpace: spaces.3)
        
        return ageFormatted
    }
    
    func getAge() -> (String, String) {
        let calendar = NSCalendar.current
        let birth = self.birthDate
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
        
        Logger.init().info("Data diff -> \(components.debugDescription)")
        let year = components.year ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0
        let months = components.month ?? 0
        var ageFormatted = ""
        var mainAgeInfo = ""
        
        if(year > 0) {
            mainAgeInfo = String(year)
            ageFormatted += addField(count: year, description: "ano")
        } else if(months > 0) {
            mainAgeInfo = String(months)
            ageFormatted += addField(count: months, description: "mes", withSpace: ",")
        } else if(weeks > 0) {
            mainAgeInfo = String(weeks)
            ageFormatted += addField(count: weeks, description: "semana", withSpace: ",")
        } else if(days > 0) {
            mainAgeInfo = String(days)
            ageFormatted += addField(count: days, description: "dia", withSpace: "e")
        }
        ageFormatted += "."
        
        
        return (mainAgeInfo, ageFormatted)
    }
    
    func addField(count: Int, description: String, withSpace: String? = nil) -> String {
        var text = ""
        
        if(count > 0) {
            
            text += " \(count) \(description)"
            text += addFieldPlural(count: count)
            if let spacer = withSpace {
                text += spacer
            }
            
        }
        Logger().debug("appending text => \(text)")
        return text
    }
    
    func addFieldPlural(count: Int) -> String {
        if(count > 1) {
            return "s"
        }
        return ""
    }
    
}
