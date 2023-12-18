//
//  OptionSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
struct OptionSection : Section {

    
    
    
    var items: [Option]
    var itemClosure: ((Option,UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .none

    typealias T = Option
    
    typealias H = HorizontalHeaderView
    
    typealias C = OptionTableViewCell
    
    typealias F = VerticalTableFooterView
    
        
    let cellHeight: CGFloat = 50
 
    
    func headerHeight() -> CGFloat {
        return 0
    }
    
    func footerHeight() -> CGFloat {
        return 90
    }
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let option = items[indexPath.row]
        let cell = C.dequeueView(with: tableView, indexPath: indexPath)
        let position : PositionType = if(indexPath.row == items.startIndex) { PositionType.first } else if(indexPath.row == items.count - 1) { PositionType.last } else { PositionType.none }
        cell.setupButton(option: option, positionType: position)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        return header
    }
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: self.footerData)
        footer.footerButton.tintColor = UIColor.red
        footer.footerLabel.font = footer.footerLabel.font.withSize(UIFont.smallSystemFontSize)
        footer.footerButton.configuration = UIButton.Configuration.gray()
        return footer
    }
    
 
    
    
}
