//
//  File.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
struct SettingsDetailsSection: Section {
    var items: [DetailModel]
    var headerMenuClosure: ((Int) -> Void)
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> HorizontalTableViewCell {
        let item = items[indexPath.row]
        let cell = HorizontalTableViewCell.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupData(field: item.name, value: item.value, subtitle: nil, isFirst: item == items.first, isLast: item == items.last)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> HorizontalHeaderView {
        let header = HorizontalHeaderView.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)

        let closure = { (action: UIAction) in
            headerMenuClosure(sectionIndex)
        }
        let action = UIAction(handler: closure)
        action.title = "Excluir"
        action.image = UIImage(systemName: "trash.circle.fill")?.withTintColor(UIColor.red.withAlphaComponent(0.7))
        
        header.headerButton.menu = UIMenu(
            title: "",
            identifier: UIMenu.Identifier(rawValue: "headerMenu"),
            children: [action]
        )
        header.headerButton.showsMenuAsPrimaryAction = true
        return header
    }
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> VerticalTableFooterView {
        let footer = VerticalTableFooterView.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.isHidden = true
        footer.setupView(info: footerData)
        return footer
    }
    
    func footerHeight() -> CGFloat {
        let size: CGFloat = if(footerData != nil) {
            100
        } else {
            0
        }

        return size
    }
    
    
    var itemClosure: ((DetailModel, UIView?) -> Void)
    
    typealias T = DetailModel
    
    typealias H = HorizontalHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = VerticalTableFooterView
    
 
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)?
    var footerData: (message: String, actionTitle: String, closure: (UIView?) -> Void)?
    let cellHeight: CGFloat = 75
    
    
}
