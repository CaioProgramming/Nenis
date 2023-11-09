//
//  VaccineCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineCollectionViewCell: UICollectionViewCell, CustomViewProtocol {
    
    let verticalIdentifier = "VaccineVerticalViewCell"
    static let horizontalIdentifier = "VaccineCollectionViewCell"
    
     var identifier = "VaccineCollectionViewCell"
     

    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var vaccineIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupVaccine(vaccine: String, progress: Float, nextDate: String, status: Status) {
        nameLabel.text = vaccine
        dateLabel.text = nextDate
        let color = status.color
        vaccineIcon.tintColor = color
        iconBackground.clipImageToCircle(color: color.withAlphaComponent(0.3))
        progressView.setProgress(progress, animated: true)
        progressView.progressTintColor = color
        
    }
    
    func buildVerticalCell() -> UINib {
        return UINib(nibName: verticalIdentifier, bundle: nil)
    }

}
