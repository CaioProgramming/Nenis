//
//  VaccineFooterView.swift
//  Nenis
//
//  Created by Caio Ferreira on 27/11/23.
//

import UIKit

class VaccineFooterView: UICollectionReusableView, CustomViewProtocol {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        footerLabel.text = NSLocalizedString("vaccineFooterDescription", comment: "")
    }
    
    @IBOutlet weak var footerLabel: UILabel!
}
