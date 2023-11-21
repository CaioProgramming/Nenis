//
//  ChildTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 07/11/23.
//

import UIKit

class ChildTableViewCell: UITableViewCell, CustomViewProtocol {
    var identifier: String = "ChildTableViewCell"
    var imageUrl: String? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageUrl = nil
    }

    @IBOutlet weak var ageDescription: UILabel!
    @IBOutlet weak var labelBlur: UIVisualEffectView!
    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childImage: UIImageView!
    @IBOutlet weak var ageContainer: UIView!
    
    @IBOutlet weak var tutorsContainer: UIView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setupChild(child: Child) {
        let radius = CGFloat(15)
        labelBlur.roundedCorner(radius: radius)
        ageContainer.roundedCorner(radius: radius)
        //tutorsContainer.roundedCorner(radius: 25)
        let color = child.gender.getGender()?.color ?? UIColor.accent
        ageContainer.backgroundColor = color.withAlphaComponent(0.3)
        //tutorsContainer.backgroundColor = color.withAlphaComponent(0.3)
        childNameLabel.text = child.name
        childAgeLabel.text = child.getAge().0
        ageDescription.text = child.getAge().1
        childAgeLabel.textColor = color
        ageDescription.textColor = color
        labelBlur.fadeIn()
        //childImage.clipImageToCircle(color: color)
       
    }
    
}
