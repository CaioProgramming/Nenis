//
//  DiaperHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 21/11/23.
//

import UIKit

class DiaperHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    static var viewType: ViewType = .header
    
    @IBOutlet weak var titleButton: UILabel!
    
    @IBOutlet weak var diaperContainer: UIView!
    @IBOutlet weak var verticalDivider: UIView!

    
    var headerAction: (() -> Void)? = nil
    
    func setupHeader(with title: String, color: UIColor) {
        titleButton.text = title
        titleButton.textColor = color
        //diaperContainer.setGradientBackground(colors: [color, color.withAlphaComponent(0.5), UIColor.systemBackground])
        //diaperContainer.clipImageToCircle(color: UIColor.clear)
        verticalDivider.backgroundColor = color
    }
    
    
}
