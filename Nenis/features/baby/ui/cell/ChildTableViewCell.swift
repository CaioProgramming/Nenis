//
//  ChildTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 07/11/23.
//

import UIKit

class ChildTableViewCell: UITableViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    
    var imageUrl: String? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHidden = true
        self.backgroundColor = UIColor.clear
        // Initialization code
    }
    
    override func prepareForReuse() {
        imageUrl = nil
    }


    @IBOutlet weak var childAgeLabel: UILabel!
    @IBOutlet weak var childNameLabel: UILabel!
    @IBOutlet weak var childImage: UIImageView!
    
    @IBOutlet weak var imageContainer: UIView!
    
    var childClosure: ((UIView?) -> Void)? = nil
 
  
    func setupChild(child: Child) {
        let color = child.gender.getGender()?.color ?? UIColor.accent
        childNameLabel.text = child.name
        childAgeLabel.text = child.getFullAge()
        childAgeLabel.textColor = color
        imageContainer.clipImageToCircle(color: UIColor.systemBackground)
        childImage.clipImageToCircle(color: UIColor.systemGray.withAlphaComponent(0.4))
        imageContainer.dropShadow(oppacity: 1, radius: 15, color: color)
        childImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        self.fadeIn()
    }
    
    @objc func imageTap(_ sender:UITapGestureRecognizer) {
        
        if let closure = childClosure {
            childImage.fadeOut(0.5,onCompletion: {
                closure(self.childImage)
                self.childImage.fadeIn()
            })
        }
    }
    
}
