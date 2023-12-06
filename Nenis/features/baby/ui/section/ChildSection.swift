//
//  ChildSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
struct ChildSection : Section {

    
    var title: String
    var subtitle: String
    var items: [Child]
    var itemClosure: ((Child, UIView?) -> Void)
    
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: (UIView?) -> Void)?
    var footerData: (message: String, actionTitle: String, closure: (UIView?) -> Void)?

 
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
        footer.fadeOut()
        return footer
    }
    
    
    typealias H = ChildHeaderView
    
    typealias C = ChildTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.titleLabel.text = title
        header.subtitleLabel.text = subtitle.capitalized
        
        return header
    }
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        let child = items[indexPath.row]
        cell.childClosure = { view in
            self.itemClosure(child, view)
         }
        cell.childImage.moa.url = child.photo
        cell.childImage.moa.onSuccess = { image in
            cell.childImage.fadeIn()
            cell.setupChild(child: child)
            
            return image
        }
        return cell
    }
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    var cellHeight: CGFloat = 400
    
    func headerHeight() -> CGFloat {
        return if(title.isEmpty && subtitle.isEmpty) { 0 } else { 75 }
    }
    
    func footerHeight() -> CGFloat {
        return 0
    }
    
    
    typealias T = Child
    
    

    
    
}
