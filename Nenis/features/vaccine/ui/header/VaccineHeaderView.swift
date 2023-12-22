//
//  VaccineHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import UIKit

class VaccineHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    static var viewType: ViewType = .header
    
    var hideCardListener: (() -> Void)? = nil
    
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tipCard: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tipCard.roundedCorner(radius: 15)
        tipCard.backgroundColor = UIColor.link.withAlphaComponent(0.4)
    }

    
    @IBAction func dismissCard(_ sender: Any) {
        tipCard.isHidden = true
    }
}
