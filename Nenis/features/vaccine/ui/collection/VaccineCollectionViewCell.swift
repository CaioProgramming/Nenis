//
//  VaccineCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import UIKit

class VaccineCollectionViewCell: UICollectionViewCell, CustomViewProtocol {
    
    static var viewType: ViewType = .cell
    
             

    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var vaccineIcon: UIImageView!
    
    @IBOutlet weak var mainContentView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.mainContentView.roundedCorner(radius: 15)
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
        self.roundedCorner(radius: 15)
    }

}


class VaccineVerticalViewCell: UICollectionViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    
    
    @IBOutlet weak var vaccineLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    func setupVaccine(label: String,vaccine: String, progress: Float, nextDate: String, status: Status) {
        nameLabel.text = vaccine
        dateLabel.text = nextDate
        let color = status.color
        vaccineLabel.text = label
        vaccineLabel.textColor = color
        vaccineLabel.clipImageToCircle(color: color.withAlphaComponent(0.3))
        progressView.setProgress(progress, animated: true)
        progressView.progressTintColor = color
        self.roundedCorner(radius: 15)
    }
}
