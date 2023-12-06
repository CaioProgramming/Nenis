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
    typealias T = Action
    typealias H = HorizontalHeaderView
    typealias C = ActivityTableViewCell
    typealias F = VerticalTableFooterView
    
    var items: [Action]
    var itemClosure: ((Action, UIView?) -> Void)
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)?
    var footerData: (message: String, actionTitle: String, closure: (UIView?) -> Void)?

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
        return header
    }
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        let activity = items[indexPath.row]
        cell.setupAction(activity: activity, isFirst: indexPath.row == 0, isLast: indexPath.row == (items.count - 1))
        return cell
    }
    
}
