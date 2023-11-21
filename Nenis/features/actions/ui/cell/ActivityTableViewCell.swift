//
//  ActivityTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 08/09/23.
//

import UIKit

class ActivityTableViewCell: UITableViewCell, CustomViewProtocol {
    
   let identifier = "ActivityTableViewCell"

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var caption: UILabel!
   
    @IBOutlet weak var topProgressLine: UIView!
    @IBOutlet weak var bottomProgressLine: UIView!
    @IBOutlet weak var iconContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupAction(activity: Action, isFirst: Bool, isLast: Bool) {
        
        let actionType = activity.type.getAction()
        icon.backgroundColor = UIColor.clear
        value.text = activity.description
        caption.textColor = UIColor.placeholderText
        caption.text = activity.formatDate()
        if let action = actionType {
            icon.image =  action.cellImage
            iconContainer.clipImageToCircle(color: action.imageTint.withAlphaComponent(0.4))
            icon.tintColor = action.imageTint
            topProgressLine.backgroundColor = action.imageTint
            bottomProgressLine.backgroundColor = action.imageTint
            topProgressLine.isHidden = isFirst
            bottomProgressLine.isHidden = isLast
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
