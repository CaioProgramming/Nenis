//
//  ActionHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class HorizontalHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
        

    static var viewType: ViewType = .header
    @IBOutlet weak var newActionButton: UIButton!
    private var buttonAction: (() -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    func setupHeader(info: (title: String,actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?) {
        
        if let headerExtras = info {
            newActionButton.setTitle(headerExtras.actionTitle, for: .normal)
            newActionButton.setImage(headerExtras.uiIcon, for: .normal)
            newActionButton.semanticContentAttribute = .forceRightToLeft

            self.buttonAction = headerExtras.closure
            titleLabel.text = headerExtras.title
            self.fadeIn()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
    }
    
    
    @IBAction func newActionTap(_ sender: UIButton) {
        
        if let closure = buttonAction {
            closure()
        }
    }
    
}
