//
//  DiaperSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
struct DiaperHomeSection : Section {

    
    
    var items: [DiaperItem]
    
    var itemClosure: ((DiaperItem, UIView?) -> Void)
    var headerData: HeaderComponent?
    
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .none


    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
        footer.isHidden = !items.isEmpty
        return footer
    }
    
    
    typealias H = HorizontalHeaderView
    
    typealias C = DiaperTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupDiapers(diapers: items)
        cell.diaperSelectClosure = { diaper in
            itemClosure(items[indexPath.row], cell)
        }
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)
        header.dividerView.isHidden = true
        return header
    }
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    var cellHeight: CGFloat = 150
    
    func headerHeight() -> CGFloat {
        return 50
    }
    
    
    typealias T = DiaperItem
   
}


struct DiaperDetailSection: Section {

    var color: UIColor
    var items: [DetailModel]
    var itemClosure: ((DetailModel, UIView?) -> Void)
    var menuClosure: ((Int) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .none

    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> HorizontalTableViewCell {
        let item = items[indexPath.row]
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupData(field: item.name, value: nil, subtitle: item.value, isFirst: false, isLast: item == items.last)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> HorizontalHeaderView {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)
        header.mainContainerView.backgroundColor = UIColor.systemBackground
        header.mainContainerView.roundTopCorners(radius: 15)
        let closure = { (action: UIAction) in
            menuClosure(sectionIndex)
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
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
        footer.mainContentView.backgroundColor = UIColor.systemBackground
        footer.mainContentView.roundBottomCorners(radius: 15)

        return footer
    }
    
    
    typealias T = DetailModel
    
    typealias H = HorizontalHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = VerticalTableFooterView

    
    var cellHeight: CGFloat = 75
    
    func headerHeight() -> CGFloat {
        return cellHeight
    }
    
    func footerHeight() -> CGFloat {
        return if(footerData == nil) { 0 } else { 150 }
    }
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    
}
