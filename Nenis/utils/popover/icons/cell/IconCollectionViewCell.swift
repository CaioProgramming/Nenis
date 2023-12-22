//
//  IconCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/12/23.
//

import UIKit

class IconCollectionViewCell: UICollectionViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    

    @IBOutlet private weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setIcon(image: UIImage?, tint: UIColor) {
        imageView.image = image
        imageView.tintColor = tint
    }
}
