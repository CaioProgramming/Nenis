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
    
    @IBOutlet weak var containerStack: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        // Initialization code
    }

    func setupData(field: String, value: String) {
        fieldLabel.text = field
        valueLabel.text = value
        self.fadeIn()
    }
    
}
