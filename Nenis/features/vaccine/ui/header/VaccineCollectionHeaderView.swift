//
//  VaccineCollectionHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 13/11/23.
//

import Foundation
import UIKit

class VaccineCollectionHeaderView: UICollectionReusableView, CustomViewProtocol {
    var identifier: String = "VaccineCollectionHeaderView"
    

    @IBOutlet weak var headerLabel: UILabel!
    
    func setTitle(with title: String) {
        headerLabel.text = title
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
