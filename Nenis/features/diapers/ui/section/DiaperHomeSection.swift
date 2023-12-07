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
        
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)?
    var footerData: (message: String, actionTitle: String, closure: (UIView?) -> Void)?

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
        
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)
        return header
    }
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    var cellHeight: CGFloat = 225
    
    
    typealias T = DiaperItem
   
}


struct DiaperDetailSection: Section {
    var items: [Action]
    var color: UIColor
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> ActivityTableViewCell {
        let action = items[indexPath.row]
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupAction(activity: action, isFirst: action == items.first, isLast: action == items.last)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> DiaperHeaderView {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(with: headerData?.title ?? "", color: color)
        return header
    }
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> VerticalTableFooterView {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
        return footer
    }
    
    var itemClosure: ((Action, UIView?) -> Void)
    
    typealias T = Action
    
    typealias H = DiaperHeaderView
    
    typealias C = ActivityTableViewCell
    
    typealias F = VerticalTableFooterView
    
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)?
    
    var footerData: (message: String, actionTitle: String, closure: (UIView?) -> Void)?
    
    var cellHeight: CGFloat = 90
    
    func headerHeight() -> CGFloat {
        return 100
    }
    

    
    
}
