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
    
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var mainContainerView: UIView!
    
    
    func setupHeader(info: (title: String,actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)?) {
        headerButton.isHidden = true
        if let headerExtras = info {
            headerButton.setTitle(headerExtras.actionTitle, for: .normal)
            headerButton.setImage(headerExtras.uiIcon, for: .normal)
            headerButton.semanticContentAttribute = .forceRightToLeft

            self.buttonAction = headerExtras.closure
            titleLabel.text = headerExtras.title
            self.fadeIn()
            headerButton.isHidden = false
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
