//
//  VaccineHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class VaccineHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    var identifier: String = "VaccineHeaderView"
    
    @IBOutlet weak var titleLabel: UILabel!
    var buttonAction: (() -> Void)? = nil

    @IBAction func headerTap(_ sender: UIButton) {
        if let closure = buttonAction {
            closure()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
