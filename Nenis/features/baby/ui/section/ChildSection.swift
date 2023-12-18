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
    
    var headerData: HeaderComponent?
    
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .none

 
    
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
        header.titleLabel.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize)

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
            cell.childImage.contentMode = .scaleAspectFill
            return image
        }
        cell.childImage.moa.onError = { _ , _ in
            cell.childImage.image = UIImage(named: "smile.out")
            cell.childImage.tintColor = UIColor.systemBackground
            cell.childImage.contentMode = .scaleAspectFit
        }
        cell.setupChild(child: child)
        cell.childImage.fadeIn()
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
