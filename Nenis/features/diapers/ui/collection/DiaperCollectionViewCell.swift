//
//  DiaperCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/11/23.
//

import UIKit
import KDCircularProgress

class DiaperCollectionViewCell: UICollectionViewCell, CustomViewProtocol {
        

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var diaperLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDiaper(diaper: Diaper) {
        
        let sizeType = diaper.getSizeType()
        let currentAmount = diaper.quantity - diaper.discarded
        let color = sizeType?.color ?? UIColor.accent
        let progress = Double(currentAmount) / Double(diaper.quantity)
        self.clipImageToCircle(color: UIColor.clear)
        progressView.progress = progress
        progressView.progressColors = [color]
        diaperLabel.textColor = diaper.getSizeType()?.color
        diaperLabel.text = diaper.type.description
        subtitleLabel.text = "\(currentAmount) de \(diaper.quantity)"
    }
}
