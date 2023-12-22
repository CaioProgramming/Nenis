//
//  ActionSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
struct ActionSection: Section {
    
    
    
    
    let cellHeight: CGFloat = 90
    typealias T = Activity
    typealias H = HorizontalHeaderView
    typealias C = ActivityTableViewCell
    typealias F = VerticalTableFooterView
    
    var items: [Activity]
    var itemClosure: ((Activity, UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle


    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        footer.setupView(info: footerData)
        footer.isHidden = !items.isEmpty
        return footer
    }
    

    func numberOfRows() -> Int {
        return items.count
    }
    


    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.setupHeader(info: headerData)
        header.mainContainerView.backgroundColor = UIColor.clear
        header.isHidden = items.isEmpty

        return header
    }
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        let activity = items[indexPath.row]
        cell.setupAction(activity: activity, isFirst: indexPath.row == 0, isLast: indexPath.row == (items.count - 1))
        return cell
    }
    
}

struct ActionSettingSection : Section {

    var items: [Activity]
    var actionType: ActionType
    var itemClosure: ((Activity, UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle
    var menuClosure: ((ActionType) -> Void)
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> HorizontalTableViewCell {
        let item = items[indexPath.row]
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.containerStack.backgroundColor = UIColor(named: "CardBackColor")
        cell.setupData(field: item.description, value: nil, subtitle: item.time.formatted(), isFirst: false, isLast: item == items.last)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> HorizontalHeaderView {
       let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)

        header.mainContainerView.backgroundColor = UIColor.systemBackground
        header.mainContainerView.roundTopCorners(radius: 15)
         let closure = { (action: UIAction) in
            menuClosure(actionType)
        }
        let action = UIAction(handler: closure)
        action.title = "Excluir"
        action.image = UIImage(systemName: "trash.circle.fill")?.withTintColor(UIColor.red.withAlphaComponent(0.7))
        header.iconImage.tintColor = actionType.imageTint
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
        footer.footerButton.tintColor = UIColor.red
        return footer
    }
    
    
    typealias T = Activity
    
    typealias H = HorizontalHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = VerticalTableFooterView
    

    
    var cellHeight: CGFloat = 75
    
    func headerHeight() -> CGFloat {
        return cellHeight
    }
    

}
