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
        self.isHidden = true
        // Initialization code
    }

    func setupItem(title: String, subtitle: String, icon: UIImage?, iconColor: UIColor = UIColor.link) {
        itemTitle.text = title
        itemSubtitle.text = subtitle
        itemIcon.preferredSymbolConfiguration = UIImage.SymbolConfiguration.init(paletteColors: [iconColor, UIColor.secondaryLabel, UIColor.systemGroupedBackground])
        itemIcon.image = icon
        self.fadeIn(1.5)
    }
    
}
