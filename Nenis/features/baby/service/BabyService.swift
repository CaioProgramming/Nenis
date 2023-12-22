//
//  BabyService.swift
//  Nenis
//
//  Created by Caio Ferreira on 28/09/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore
import os


class BabyService: DatabaseProtocol {
    
    
    
    typealias T = Child
    var path = "Childs"
    var dataSource: FirebaseDataSource<Child>?
    
    init() {
        self.dataSource = FirebaseDataSource(databaseProtocol: self)
    }
    
    
}
