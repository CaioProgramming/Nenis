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
        imageContainer.clipImageToCircle(color: UIColor.systemGroupedBackground)
        childImage.clipImageToCircle(color: UIColor.label)
        imageContainer.dropShadow(oppacity: 0.8, color: color)
        childImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageTap)))
        self.fadeIn()
    }
    
    @objc func imageTap(_ sender:UITapGestureRecognizer) {
        
        if let closure = childClosure {
            childImage.scaleAnimation(xScale: 0.9, yScale: 0.9, onCompletion: {
                self.childImage.scaleAnimation(xScale: 1.0, yScale: 1.0, onCompletion: {
                    closure(self.childImage)

                })
            })
        }
    }
    
}
