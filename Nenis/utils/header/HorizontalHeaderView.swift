//
//  ActionHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class HorizontalHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
        

    @IBOutlet weak var newActionButton: UIButton!
    private var buttonAction: (() -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
  
    
    @IBOutlet weak var container: UIView!
    func setupHeader(title:String, buttonInfo: (text: String, image: String?, buttonClosure: (() -> Void))?) {
        
        if let buttonExtras = buttonInfo {
            newActionButton.setTitle(buttonExtras.text, for: .normal)
            if let icon = buttonExtras.image {
                newActionButton.setImage(UIImage(systemName: icon), for: .normal)
                newActionButton.semanticContentAttribute = .forceRightToLeft

            }
            self.buttonAction = buttonExtras.buttonClosure
        }
        titleLabel.text = title
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func newActionTap(_ sender: UIButton) {
        
        if let closure = buttonAction {
            closure()
        }
    }
    
}
