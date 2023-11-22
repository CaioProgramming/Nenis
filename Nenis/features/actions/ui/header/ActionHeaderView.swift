//
//  ActionHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class ActionHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    var identifier: String = "ActionHeaderView"
    

    @IBOutlet weak var newActionButton: UIButton!
    var buttonAction: (() -> Void)? = nil
    @IBOutlet weak var titleLabel: UILabel!
  
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func setupHeader(title:String) {
        newActionButton.setImage(UIImage(systemName: "plus"), for: .normal)
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
