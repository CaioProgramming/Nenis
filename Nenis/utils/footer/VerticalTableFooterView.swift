//
//  ButtonTableViewFooterView.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/11/23.
//

import UIKit

class VerticalTableFooterView: UITableViewHeaderFooterView, CustomViewProtocol {
    

    static var viewType: ViewType = .footer
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var footerButton: UIButton!
    var footerClosure: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        self.backgroundColor = UIColor.clear
    }
    
    func setupView(info: (message: String,actionTitle: String, closure: () -> Void)?) {
        if let footerInfo = info {
            footerLabel.text = footerInfo.message
            footerButton.setTitle(footerInfo.actionTitle, for: .normal)
            self.footerClosure = footerInfo.closure
            self.fadeIn()
        }
       
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        if let closure = footerClosure {
            closure()
        }
    }
}
