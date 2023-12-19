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
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> VerticalTableFooterView {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.isHidden = true
        return footer
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> HorizontalHeaderView {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.isHidden = true
        return header
    }
}
