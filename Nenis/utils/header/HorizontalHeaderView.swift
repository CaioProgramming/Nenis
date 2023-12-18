//
//  ActionHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class HorizontalHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
        

    static var viewType: ViewType = .header
    @IBOutlet weak var headerButton: UIButton!
    private var buttonAction: ((UIView?) -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    
    
    func setupHeader(info: HeaderComponent?) {
        
        headerButton.setTitle("", for: .normal)
        mainContainerView.isHidden = true
        if let headerExtras = info {
            headerButton.setTitle(headerExtras.actionLabel, for: .normal)
            headerButton.setImage(headerExtras.actionIcon, for: .normal)
            headerButton.semanticContentAttribute = .forceRightToLeft

            self.buttonAction = headerExtras.actionClosure
            titleLabel.text = headerExtras.title
            self.fadeIn()
            if let titleIcon = headerExtras.trailingIcon {
                iconImage.isHidden = false
                iconImage.image = titleIcon
                
            } else {
                iconImage.heightConstraint?.constant = 0.0
                iconImage.widthConstraint?.constant = 0.0
            }
            mainContainerView.fadeIn()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        
    }
    
    
    @IBAction func newActionTap(_ sender: UIButton) {
        
        if let closure = buttonAction {
        
            sender.scaleAnimation(xScale: 0.9, yScale: 0.9, onCompletion: {
                sender.scaleAnimation(xScale: 1, yScale: 1, onCompletion: {
                    closure(sender)
                })
            })
        }
    }
    
}
