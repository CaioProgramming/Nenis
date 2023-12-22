//
//  VaccineCollectionHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 13/11/23.
//

import Foundation
import UIKit

class VaccineCollectionHeaderView: UICollectionReusableView, CustomViewProtocol {
    
    static var viewType: ViewType = .reusableView
    
    @IBOutlet weak var headerLabel: UILabel!
    
    func setTitle(with title: String) {
        headerLabel.text = title
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
 
}
