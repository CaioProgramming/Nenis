//
//  CustomViewProtocol.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import Foundation
import UIKit
protocol CustomViewProtocol { }

extension CustomViewProtocol {
    
    static var identifier : String { get { return "\(self)"} }
    
    static func buildNib() -> UINib {
        return UINib(nibName: Self.identifier, bundle: nil)
    }
    
    func getIdentifier() -> String {
        return Self.identifier

    }
    
    func getNib() -> UINib {
        return Self.buildNib()
    }
}
