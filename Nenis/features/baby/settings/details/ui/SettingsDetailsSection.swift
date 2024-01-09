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
    var saveDataClosure: ((String, String) -> Void)? = nil

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
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> InputOptionFooterView {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.isHidden = true
        guard let data = footerData else {
            
            return footer
        }
        footer.fieldTextField.placeholder = headerData?.title
        footer.valueTextField.placeholder = data.actionLabel
        footer.setupFooter(closure: saveDataClosure)
        footer.fadeIn()
        return footer
    }
    
    
    typealias T = DetailModel
    
    typealias H = HorizontalHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = InputOptionFooterView
    
 
    let cellHeight: CGFloat = 50
    func footerHeight() -> CGFloat {
        return if(footerData != nil){ 75 } else { 0 }
    }
    
    
}
