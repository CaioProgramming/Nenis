//
//  Child.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/09/23.
//

import Foundation
import FirebaseFirestoreSwift

public struct Child: Codable {
    @DocumentID var id: String?
    let name: String
    let birthDate: Date
    let photo: String
    let tutors: [String]
    var actions: [Action]
    enum CodingKeys: String, CodingKey {
        case name
        case birthDate
        case photo
        case tutors
        case actions
    }
}
