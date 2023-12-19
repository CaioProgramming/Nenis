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
    var itemClosure: ((DetailModel, UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var headerMenuClosure: ((Int) -> Void)
    var editingStyle: UITableViewCell.EditingStyle = .delete
    var isSettings: Bool = false

    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> HorizontalTableViewCell {
        let item = items[indexPath.row]
        let cell = HorizontalTableViewCell.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.containerStack.backgroundColor = UIColor(named: "CardBackColor")
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
        if(isSettings) {
            footer.footerButton.tintColor = UIColor.red
            footer.footerButton.configuration = UIButton.Configuration.tinted()
        }
        footer.contentView.isHidden = footerData == nil
        return footer
    }
    
    
    typealias T = DetailModel
    
    typealias H = HorizontalHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = VerticalTableFooterView
    
 

    let cellHeight: CGFloat = 75
    
    
}
