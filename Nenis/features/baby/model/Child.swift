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

public struct Child: DocumentProtocol {
    var id: String?
    var name: String
    var birthDate: Date
    var photo: String
    var gender: String
    var tutors: [String]
    var actions: [Activity] = []
    var vaccines: [Vaccination] = []
    var diapers: [Diaper] = []
    var extraInfo: [ExtraData] = []
    var weightData: [UpdateData] = []
    var heightData: [UpdateData] = []
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case photo
        case gender
        case tutors
        case actions
        case vaccines
        case diapers
        case extraInfo
        case weightData
        case heightData
    }
}

struct UpdateData: Codable, Equatable {
    let value: Double
    var date: Date = Date()
}

struct ExtraData: Codable, Equatable {
    var icon: String?
    var title: String
    var infos: [DetailModel]
}

struct Vaccination: Codable {
    let vaccine: String
    let dose: Int
}

enum Gender : Codable, CaseIterable {
    
    case boy, girl
    
    var description: String { get { return "\(self)".uppercased() } }
    
    var info: String {
        get {
            switch self {
            case .boy:
                NSLocalizedString("Masculino", comment: "")
            case .girl:
                "Feminino"
            }
        }
    }
    
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
        let birth = self.birthDate
        let calendar = NSCalendar.current
        let currentDate = Date.now
        let components = calendar.dateComponents([.year, .month, .weekOfYear, .day], from: birth, to: currentDate)
        
        Logger.init().info("Data diff -> \(components.debugDescription)")
        let year = components.year ?? 0
        let months = components.month ?? 0
        let weeks = components.weekOfYear ?? 0
        let days = components.day ?? 0
        
        var ageFormatted = ""
        let spaces = getSpacers(year: year, months: months, weeks: weeks, days: days)
        
        ageFormatted += addField(count: year, description: "ano", withSpace: spaces.0, plural: nil)
        ageFormatted += addField(count: months, description: "mes", withSpace: spaces.1, plural: "es")
        ageFormatted += addField(count: weeks, description: "semana", withSpace: spaces.2, plural: nil)
        ageFormatted += addField(count: days, description: "dia", withSpace: spaces.3, plural: nil)
        
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
            ageFormatted += addField(count: year, description: "ano", plural: nil)
        } else if(months > 0) {
            mainAgeInfo = String(months)
            ageFormatted += addField(count: months, description: "mes", withSpace: ",", plural: "es")
        } else if(weeks > 0) {
            mainAgeInfo = String(weeks)
            ageFormatted += addField(count: weeks, description: "semana", withSpace: ",", plural: nil)
        } else if(days > 0) {
            mainAgeInfo = String(days)
            ageFormatted += addField(count: days, description: "dia", withSpace: "e", plural: nil)
        }
        ageFormatted += "."
        
        
        return (mainAgeInfo, ageFormatted)
    }
    
    func addField(count: Int, description: String, withSpace: String? = nil, plural: String?) -> String {
        var text = ""
        
        if(count > 0) {
            
            text += " \(count) \(description)"
            text += addFieldPlural(count: count, plural: plural)
            if let spacer = withSpace {
                text += spacer
            }
            
        }
        Logger().debug("appending text => \(text)")
        return text
    }
    
    func addFieldPlural(count: Int, plural: String?) -> String {
        if(count > 1) {
            return plural ?? "s"
        }
        return ""
    }
    
}
