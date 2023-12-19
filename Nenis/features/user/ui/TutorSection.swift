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
        let placeHolder = UIImage(named: "smile.out")
        cell.iconImage.loadImage(
                                url: tutor.photoURL,
                                 placeHolder: placeHolder,
                                 onSuccess: {
                                    cell.iconImage.contentMode = .scaleAspectFill
                                    cell.iconImage.clipImageToCircle(color: UIColor.systemGray5)
                                 },
                                 onFailure: {
                                    cell.iconImage.clipImageToCircle(color: UIColor.link.withAlphaComponent(0.4))
                                    cell.iconImage.backgroundColor = UIColor.systemGray5
                                    cell.iconImage.image = placeHolder
                                    cell.iconImage.contentMode = .scaleAspectFit
                                    
                                 }
        )
        cell.containerView.fadeIn()
        return cell
    }

    
    typealias T = Tutor
    
    typealias H = HorizontalHeaderView
    
    typealias C = TutorTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    var cellHeight: CGFloat = 80
    
    
}
