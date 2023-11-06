//
//  VaccineCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "VaccineCollectionViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "VaccineCollectionViewCell", bundle: nil)
    }

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var vaccineIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupVaccine(vaccine: String, progress: Float, nextDate: String) {
        nameLabel.text = vaccine
        dateLabel.text = nextDate
        vaccineIcon.clipImageToCircle(color: UIColor.blue.withAlphaComponent(0.8))
    }

}
