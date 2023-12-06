//
//  VaccineHorizontalTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/12/23.
//

import UIKit

class VaccineHorizontalTableViewCell: UITableViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    

    @IBOutlet weak var itemIcon: UIImageView!
    @IBOutlet weak var itemSubtitle: UILabel!
    @IBOutlet weak var itemTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupItem(title: String, subtitle: String, icon: UIImage?, iconColor: UIColor = UIColor.link) {
        itemTitle.text = title
        itemSubtitle.text = subtitle
        itemIcon.image = icon
        itemIcon.tintColor = iconColor
    }
    
}
