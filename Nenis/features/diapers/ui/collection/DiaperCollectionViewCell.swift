//
//  DiaperCollectionViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 20/11/23.
//

import UIKit
import KDCircularProgress

class DiaperCollectionViewCell: UICollectionViewCell, CustomViewProtocol {
    static var viewType: ViewType = .cell
    
        

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var diaperLabel: UILabel!
    @IBOutlet weak var progressView: KDCircularProgress!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupDiaper(diaper: Diaper, discarded: Int) {
        
        let sizeType = diaper.getSizeType()
        let currentAmount = diaper.quantity - discarded
        let color = sizeType?.color ?? UIColor.accent
        let progress = Double(currentAmount) / Double(diaper.quantity)
        progressView.progress = progress
        progressView.progressColors = [color]
        progressView.trackThickness = 0.5
        diaperLabel.textColor = diaper.getSizeType()?.color
        diaperLabel.text = diaper.type.description
        diaperLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .headline).pointSize)
        subtitleLabel.text = "\(currentAmount) de \(diaper.quantity)"
        //self.clipImageToCircle(color: UIColor.clear)

    }
}
