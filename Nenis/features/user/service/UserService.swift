//
//  UserService.swift
//  Nenis
//
//  Created by Caio Ferreira on 11/12/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseFirestore

class UserService: DatabaseProtocol {
    
    internal var dataSource: FirebaseDataSource<Tutor>?
    
    
    typealias T = Tutor
    internal var path = "tutors"
    
    init() {
        self.dataSource = FirebaseDataSource<T>(databaseProtocol: self)
    }

}
