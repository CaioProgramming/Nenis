//
//  ChildSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
import SDWebImage

struct ChildSection : Section {
    
    var title: String
    var subtitle: String
    var items: [Child]
    var tutors: [Tutor] = []
    var itemClosure: ((Child, UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    
    var editingStyle: UITableViewCell.EditingStyle = .none

 
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupData(tutors: tutors, closure: {
            if let closure = footerData?.actionClosure {
                closure(footer)
            }
        })
        footer.fadeIn()
        return footer
    }
    
    
    typealias H = ChildHeaderView
    
    typealias C = ChildTableViewCell
    
    typealias F = TutorsFooterView
    
    
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
        cell.childImage.loadImage(url: child.photo, placeHolder: UIImage(named: "smile.out"), onSuccess: {
            cell.childImage.fadeIn()
        }, onFailure: {
            cell.childImage.tintColor = child.gender.getGender()?.color
            cell.childImage.backgroundColor = UIColor.systemGray6
        })
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
        return if(tutors.isEmpty) { 0 } else { 70 }
    }
    
    
    typealias T = Child
    
    

    
    
}
