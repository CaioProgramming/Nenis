//
//  TutorSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 15/12/23.
//

import Foundation
import UIKit
struct TutorSection: Section {
  
    
    var items: [Tutor]
    
    var itemClosure: ((Tutor, UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .delete
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> TutorTableViewCell {
        let tutor = items[indexPath.row]
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupInfo(name: tutor.name)
        cell.iconImage.moa.url = tutor.photoURL
        cell.iconImage.moa.onSuccess = { image in
            cell.iconImage.image = image
            return image
        }
        cell.containerView.fadeIn()
        return cell
    }

    
    typealias T = Tutor
    
    typealias H = HorizontalHeaderView
    
    typealias C = TutorTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    var cellHeight: CGFloat = 80
    
    
}
