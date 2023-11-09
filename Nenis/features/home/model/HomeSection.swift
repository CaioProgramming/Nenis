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
    case actions,vaccines, child
}

struct VaccineSection: Section {
    
    var items: [VaccineItem]
    
    typealias T = VaccineItem
    
    
    var type: SectionType
    
    var title: String
    
}

struct ActionSection: Section {
    var items: [Action]
    
    typealias T = Action
    
    var type: SectionType
    
    var title: String
    
}

struct ChildSection : Section {
    var items: [Child]
    
    typealias T = Child
    
    var type: SectionType
    
    var title: String
    var subtitle: String
    
    
}
