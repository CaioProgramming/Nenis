//
//  Vaccine.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import Foundation

enum Vaccine: Codable, CaseIterable {
    case BCG,HPB,
         PNT,VP,
         PNC,RTV,
         MNGC,FBA,
         HPA,TRV,
         TTRV,VRC
    
    var description: String { get { return "\(self)".uppercased() } }
    
    var periods: [Int] {
        get {
            switch self {
                
            case .BCG, .HPB:
                [0]
            case .PNT, .VP: 
                [2, 4, 6, 48]
                
            case .RTV:
                [2, 4]
                
            case .PNC:
                [2, 4, 12]
                
            case .MNGC:
                [3, 5, 12]
            case .FBA:
                [9]
            case .HPA, .TTRV :[15]
            case .TRV: [12]
            case .VRC: [48]
            }
        }
    }



    var title : String {
        get {
            switch self {
                
            case .BCG:
                description
            case .HPB:
                "Hepatitie B"
            case .PNT:
                "Penta/DTP"
            case .VP:
                "VIP/VOP"
            case .PNC:
                "Pneumocócica 10"
            case .RTV:
                "Rota Vírus"
            case .MNGC:
                "Meningócica C"
            case .FBA:
                "Febre Amarela"
            case .TTRV:
                "Tetra Viral"
            case .HPA:
                "Hepatite A"
            case .TRV:
                "Tríplice Viral"
            case .VRC: "Varicela"
                
            }
            
        
        }
    }
}

extension String {
    func getVaccine(rawValue: String) -> Vaccine? {
       return Vaccine.allCases.first(where: { element in
            element.description.caseInsensitiveCompare(rawValue) == .orderedSame
        })
    }
}
