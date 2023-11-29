//
//  DiaperFooterCollectionReusableView.swift
//  Nenis
//
//  Created by Caio Ferreira on 24/11/23.
//

import UIKit

class CollectionFooterView:  UICollectionReusableView, CustomViewProtocol {
        

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var footerClosure: (() -> Void)? = nil
    @IBAction func footerAction(_ sender: UIButton) {
        if let closure = footerClosure {
            closure()
        }
    }
}
