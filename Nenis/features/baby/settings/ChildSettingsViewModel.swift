//
//  ChildSettingsViewModel.swift
//  Nenis
//
//  Created by Caio Ferreira on 29/11/23.
//

import Foundation

protocol SettingsDelegate {
    func retrieveSections(sections: [any Section])
    func taskError(message: String)
}

class ChildSettingsViewModel: DatabaseDelegate {
    
    var currentChild: Child? = nil
    
    func setupChild(child: Child) {
        self.currentChild = child
    }
    
    func buildSections() {
        
    }
    
    typealias T = Child
    
    
}
