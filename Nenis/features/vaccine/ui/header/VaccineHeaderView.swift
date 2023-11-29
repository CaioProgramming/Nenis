//
//  VaccineHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class VaccineHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    var buttonAction: (() -> Void)? = nil

    @IBOutlet weak var headerAction: UIButton!
    func setButtonAction(action: @escaping (() -> Void)) {
        self.buttonAction = action
        headerAction.isHidden = false
    }
    
    @IBAction func headerTap(_ sender: UIButton) {
        if let closure = buttonAction {
            closure()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
