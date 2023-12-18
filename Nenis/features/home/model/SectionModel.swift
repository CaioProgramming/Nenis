//
//  HomeSections.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import Foundation
import UIKit


protocol Section<T, H, C, F> {
    associatedtype T
    associatedtype H where H: CustomViewProtocol
    associatedtype C where C: CustomViewProtocol
    associatedtype F where F: CustomViewProtocol
    var items: [T] { get }
    var headerData: HeaderComponent? { get }
    var footerData: FooterComponent? { get }
    var cellHeight: CGFloat { get }
    var editingStyle: UITableViewCell.EditingStyle { get }
    func numberOfRows() -> Int
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F
    var itemClosure: ((T, UIView?) -> Void) { get }
    func footerHeight() -> CGFloat
    func headerHeight() -> CGFloat
    
    
}

extension [any Section] {
    func registerAllSectionsToTableView(_ tableView: UITableView) {
        self.forEach({ section in
            section.registerTableViewCells(tableView)
        })
    }
}

struct Component {
    let nib: UINib
    let identifier: String
    let viewType: ViewType
    
}

struct HeaderComponent {
    let title: String
    let actionLabel: String?
    let actionIcon: UIImage?
    let trailingIcon: UIImage?
    let actionClosure: ((UIView?) -> Void)?
}

struct FooterComponent {
    let message: String
    let actionLabel: String
    let messageIcon: UIImage?
    let actionClosure: ((UIView?) -> Void)?
}

extension Section {
    
    
    
    func getUIComponents() -> [Component] {
        
        return [ C.getComponent(),H.getComponent(), F.getComponent() ]
    }

    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        return H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
    }
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        return F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
    }

  func registerTableViewCells(_  tableView: UITableView) {
        self.getUIComponents().forEach({ nibData in
            switch nibData.viewType {
            case  .cell, .reusableView:
                tableView.register(nibData.nib, forCellReuseIdentifier: nibData.identifier)
            case .header, .footer:
                tableView.register(nibData.nib, forHeaderFooterViewReuseIdentifier: nibData.identifier)
            }
        })
    }
    
    func footerHeight() -> CGFloat {
        return if(footerData == nil) { 0.0 } else { 100 }
       
    }
    
    func headerHeight() -> CGFloat {
        return if(headerData == nil) { 0.0 } else { 75 }
    }
    
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func performItemClosure(index: Int) {
        let item = items[index]
        itemClosure(item, nil)
    }
}
