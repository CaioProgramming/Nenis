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
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage? , closure: (UIView?) -> Void)? { get }
    var footerData: (message: String,actionTitle: String, closure: (UIView?) -> Void)? { get }
    var cellHeight: CGFloat { get }
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

extension Section {
    
    func getUINibs() -> [(nib: UINib, identifier: String, type: ViewType)] {
        
        return [(C.buildNib(), C.identifier, C.viewType),(H.buildNib(), H.identifier, H.viewType), (F.buildNib(), F.identifier, H.viewType) ]
    }
    

  func registerTableViewCells(_  tableView: UITableView) {
        self.getUINibs().forEach({ nibData in
            switch nibData.type {
            case  .cell, .reusableView:
                tableView.register(nibData.nib, forCellReuseIdentifier: nibData.identifier)
            case .header, .footer:
                tableView.register(nibData.nib, forHeaderFooterViewReuseIdentifier: nibData.identifier)
            }
        })
    }
    
    func footerHeight() -> CGFloat {
        return if(footerData == nil) { 0.0 } else { 100.0 }
       
    }
    
    func headerHeight() -> CGFloat {
        return if(headerData == nil) { 0.0 } else { 100.0 }
    }
    
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func performItemClosure(index: Int) {
        let item = items[index]
        itemClosure(item, nil)
    }
}
