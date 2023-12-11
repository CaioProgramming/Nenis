//
//  OptionTableViewCell.swift
//  Nenis
//
//  Created by Caio Ferreira on 29/11/23.
//

import UIKit

class OptionTableViewCell: UITableViewCell, CustomViewProtocol {
    
   static var viewType: ViewType = .cell
   static func dequeueView(with tableView: UITableView, indexPath: IndexPath) -> Self {
       let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier, for: indexPath) as! Self
        return cell
    }
    

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var optionContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupButton(option: Option, positionType: PositionType) {
        titleLabel.text = option.title
        iconImageView.image = option.icon
        iconContainer.backgroundColor = option.color
        iconContainer.roundedCorner(radius: 10)
        dividerView.isHidden = positionType == .last
        
        switch positionType {
        case .first:
            optionContainer.roundTopCorners(radius: 10)
        case .none:
            optionContainer.roundedCorner(radius: 0)
        case .last:
            optionContainer.roundBottomCorners(radius: 10)
        }
    }
    
}

enum PositionType {
    case first, none, last
}
