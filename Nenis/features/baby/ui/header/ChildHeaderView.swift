//
//  ChildHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 07/11/23.
//

import UIKit

class ChildHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    static var viewType: ViewType = .header
    

    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    

    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
