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


    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childImage: UIImageView!
    
    @IBOutlet weak var gradientContainer: UIView!
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    func setupChild(child: Child) {
    
        let color = child.gender.getGender()?.color ?? UIColor.accent
        childNameLabel.text = child.name
        childAgeLabel.text = child.getFullAge()
        childAgeLabel.textColor = color

        
       let gradient = CAGradientLayer()
                gradient.frame = gradientContainer.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.systemBackground.withAlphaComponent(0.5).cgColor, UIColor.systemBackground.cgColor]
                gradient.locations = [0, 0.5, 1]
               gradientContainer.layer.addSublayer(gradient)
        
    }
    
}
