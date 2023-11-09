//
//  CustomViewProtocol.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import Foundation
import UIKit
protocol CustomViewProtocol {
    var identifier: String { get }
}

extension CustomViewProtocol {
    func buildNib() -> UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
}
