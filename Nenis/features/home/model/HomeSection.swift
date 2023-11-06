//
//  HomeSections.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import Foundation


protocol Section<T> {
    associatedtype T
    var items: [T] { get }
    var type: SectionType { get }
    var title: String { get }
}

enum SectionType {
    case actions,vaccines
}

struct VaccineSection: Section {
    
    var items: [String]
    
    typealias T = String
    
    
    var type: SectionType
    
    var title: String
    
}

struct ActionSection: Section {
    var items: [Action]
    
    typealias T = Action
    
    var type: SectionType
    
    var title: String
    
    
}
