//
//  CustomViewProtocol.swift
//  Nenis
//
//  Created by Caio Ferreira on 06/11/23.
//

import Foundation
import UIKit
protocol CustomViewProtocol {
   static var viewType: ViewType { get }
}

enum ViewType {
    case cell, header, footer, reusableView
}

extension CustomViewProtocol {
    
    static func getComponent() -> Component {
        return Component(nib: buildNib(), identifier: identifier, viewType: viewType)
    }
    
    static var identifier : String { get { return "\(self)"} }
    
    static func buildNib() -> UINib {
        return UINib(nibName: Self.identifier, bundle: nil)
    }
    
    static func registerTableViewCell(with tableView: UITableView) {
        if(viewType == .cell) {
            tableView.register(buildNib(), forCellReuseIdentifier: identifier)
        } else {
            tableView.register(buildNib(), forHeaderFooterViewReuseIdentifier: identifier)
        }
    }
    
    static func dequeueTableViewCell(with tableView: UITableView, indexPath: IndexPath) -> Self {
         let cell = tableView.dequeueReusableCell(withIdentifier: Self.identifier, for: indexPath) as! Self
         return cell
    }
    
    static func dequeueHeaderOrFooter(with tableView: UITableView, sectionIndex: Int) -> Self {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: Self.identifier) as! Self
    }
    
    static func dequeueCollectionCell(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> Self {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! Self
        return cell
    }
    
    static func dequeueReusableSupplementaryView(_ collectionView: UICollectionView, at indexPath: IndexPath)  -> Self {
        let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: getKindOfReusableView(), withReuseIdentifier: identifier, for: indexPath) as! Self
        return supplementaryView
    }
    
    func getIdentifier() -> String {
        return Self.identifier

    }
    
    func getNib() -> UINib {
        return Self.buildNib()
    }
    
    static func getKindOfReusableView() -> String {
       return if(viewType == .footer) { UICollectionView.elementKindSectionFooter } else { UICollectionView.elementKindSectionHeader }
    }
    
}
