//
//  SimpleHorizontalTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 30/11/23.
//

import UIKit

class HorizontalTableViewCell: UITableViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var containerStack: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        self.selectionStyle = .none
        // Initialization code
    }
    
    func setupData(field: String?, value: String?, subtitle: String?, isFirst: Bool, isLast: Bool) {
        fieldLabel.text = field
        valueLabel.text = value
        subtitleLabel.text = subtitle
        if (isFirst && isLast) {
            containerStack.roundedCorner(radius: 15)
        } else if(isFirst) {
            containerStack.roundTopCorners(radius: 15)
        } else if(isLast) {
            containerStack.roundBottomCorners(radius: 15)
        } else {
            containerStack.roundedCorner(radius: 0)
        }
        self.fadeIn()
    }
    
}
