//
//  DiaperFooterCollectionReusableView.swift
//  Nenis
//
//  Created by Caio Ferreira on 24/11/23.
//

import UIKit

class DiaperFooterCollectionReusableView: UICollectionReusableView, CustomViewProtocol {
    
    var identifier: String = "DiaperFooterView"
    

    @IBOutlet weak var footerButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var footerClosure: (() -> Void)? = nil
    @IBAction func footerAction(_ sender: UIButton) {
        if let closure = footerClosure {
            closure()
        }
    }
}
