//
//  TutorTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 15/12/23.
//

import UIKit

class TutorTableViewCell: UITableViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         containerView.roundedCorner(radius: 15)
         containerView.isHidden = true

        // Initialization code
    }

    func setupInfo(name: String?) {
        nameLabel.text = name
    }
    

   
    
}
