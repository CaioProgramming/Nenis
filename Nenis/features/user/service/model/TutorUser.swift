//
//  User.swift
//  Nenis
//
//  Created by Caio Ferreira on 11/12/23.
//

import Foundation

struct Tutor: DocumentProtocol, Codable, Equatable {
    var id: String?
    let name: String?
    let photoURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case photoURL
    }
}
