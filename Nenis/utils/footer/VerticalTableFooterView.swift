//
//  ButtonTableViewFooterView.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/11/23.
//

import UIKit

class VerticalTableFooterView: UITableViewHeaderFooterView, CustomViewProtocol {
    

    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var footerButton: UIButton!
    var footerClosure: (() -> Void)? = nil

    @IBOutlet weak var footerContainer: UIView!
    func setupView(info: (String, String), closure: @escaping (() -> Void)) {
        footerLabel.text = info.0
        footerButton.setTitle(info.1, for: .normal)
        self.footerClosure = closure
        self.footerContainer.isHidden = false
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        if let closure = footerClosure {
            closure()
        }
    }
}
