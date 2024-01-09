//
//  ButtonTableViewFooterView.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/11/23.
//

import UIKit

class VerticalTableFooterView: UITableViewHeaderFooterView, CustomViewProtocol {
    

    @IBOutlet weak var mainContentView: UIView!
    static var viewType: ViewType = .footer
    @IBOutlet weak var footerLabel: UILabel!
    @IBOutlet weak var footerButton: UIButton!
    @IBOutlet weak var footerIcon: UIImageView!
    var footerClosure: ((UIView?) -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
    }
    
    func setupView(info: FooterComponent?) {
         if let footerInfo = info {
            footerLabel.text = footerInfo.message
            footerButton.setTitle(footerInfo.actionLabel, for: .normal)
             footerIcon.image = footerInfo.messageIcon?.image
             footerIcon.tintColor = footerInfo.messageIcon?.tintColor
            footerIcon.isHidden = footerInfo.messageIcon == nil
             footerButton.isHidden = footerInfo.actionClosure == nil
            self.footerClosure = footerInfo.actionClosure
            self.fadeIn()
        }
       
    }

    @IBAction func buttonTap(_ sender: UIButton) {
        if let closure = footerClosure {
            closure(sender)
        }
    }
}
