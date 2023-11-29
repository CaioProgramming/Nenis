//
//  DiaperHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 21/11/23.
//

import UIKit

class DiaperHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var headerActionButton: UIButton!
    
    @IBAction func headerButtonTap(_ sender: Any) {
        if let headerClosure = headerAction {
            headerClosure()
        }
    }
    
    var headerAction: (() -> Void)? = nil
    
    func setupHeader(with title: String) {
        titleLabel.text = title
    }
    
    
}
