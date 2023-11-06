//
//  ActivityTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/09/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    static let identifier = "ActivityTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "ActivityTableViewCell", bundle: nil)
    }

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var caption: UILabel!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupAction(activity: Action) {
        
        let actionType = activity.type.getAction()
        icon.backgroundColor = UIColor.clear
        value.text = activity.description
        caption.textColor = UIColor.placeholderText
        caption.text = activity.formatDate()
        if let action = actionType {
            icon.image =  action.cellImage
            icon.tintColor = action.imageTint
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
