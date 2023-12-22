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
    
    func dequeueCollectionCell(with collectionView: UICollectionView, indexpath: IndexPath) -> C
    func dequeueReusableViewHeader(_ collectionView: UICollectionView, at indexPath: IndexPath) -> H
    func dequeueReusableViewFooter(_ collectionView: UICollectionView, at indexPath: IndexPath) -> F
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

struct IconConfiguration {
    let image: UIImage?
    var tintColor: UIColor? = UIColor.accent
}

struct HeaderComponent {
    let title: String
    let actionLabel: String?
    let actionIcon: IconConfiguration?
    let trailingIcon: IconConfiguration?
    let actionClosure: ((UIView?) -> Void)?
}

struct FooterComponent {
    let message: String
    let actionLabel: String
    let messageIcon: IconConfiguration?
    let actionClosure: ((UIView?) -> Void)?
}

extension Section {
    
    func dequeueReusableView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> CustomViewProtocol {
        if(kind == UICollectionView.elementKindSectionHeader) {
            return dequeueReusableViewFooter(collectionView, at: indexPath)
        } else {
            return dequeueReusableViewHeader(collectionView, at: indexPath)
        }
    }
    
    func getUIComponents() -> [Component] {
        
        return [ C.getComponent(),H.getComponent(), F.getComponent() ]
    }

    func dequeueReusableViewHeader(_ collectionView: UICollectionView,  at indexPath: IndexPath) -> H {
        
        return H.dequeueReusableSupplementaryView(collectionView, at:  indexPath)
        
        
    }
    func dequeueReusableViewFooter(_ collectionView: UICollectionView,at indexPath: IndexPath) -> F {
        
        return F.dequeueReusableSupplementaryView(collectionView, at:  indexPath)
        
        
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        return H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
    }
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        return F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
    }
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        return C.dequeueTableViewCell(with: tableView,indexPath: indexPath)
    }
    func dequeueCollectionCell(with collectionView: UICollectionView, indexpath: IndexPath) -> C {
        return C.dequeueCollectionCell(_: collectionView, cellForItemAt: indexpath)
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
        return if(headerData == nil) { 0.0 } else { 60 }
    }
    
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func performItemClosure(index: Int) {
        let item = items[index]
        itemClosure(item, nil)
    }
}
