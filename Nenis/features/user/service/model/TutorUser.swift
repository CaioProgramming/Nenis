//
//  User.swift
//  Nenis
//
//  Created by Caio Ferreira on 11/12/23.
//

import Foundation

struct TutorUser: Codable, Equatable {
    let uid: String
    let displayName: String
    let photoURL: String
    
    enum CodingKeys: String, CodingKey {
        case uid
        case displayName
        case photoURL
    }
}
