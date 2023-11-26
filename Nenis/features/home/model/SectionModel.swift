//
//  HomeSections.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/11/23.
//

import Foundation
import UIKit


protocol Section<T> {
    associatedtype T
    var items: [T] { get }
    var title: String { get }
    var cellHeight: CGFloat { get }
    var headerHeight: CGFloat { get }
    var cellIdentifier: String { get }
    var headerIdentifier: String { get }
    func numberOfRows() -> Int
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView
    var itemClosure: ((T) -> Void)? { get }
    var headerClosure: ((Self) -> Void)? { get }

}

protocol SectionsProtocol {
    func requestNewAction()
    func openVaccines()
    func openDiapers()
    
}




struct VaccineSection: Section {
    

    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! VaccineHeaderView
        header.titleLabel.text = title
        header.setButtonAction {
            if let headClosure = headerClosure {
                headClosure(self)
            }
        }
        return header
    }
    
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! VaccineTableViewCell
        cell.updateVaccines(vaccineList: items)
        cell.selectVaccine = { item in
            if let closure = itemClosure {
                closure(item)
            }
        }
        return cell
    }
    
    

    
    var cellIdentifier: String = VaccineTableViewCell().identifier
    
    var headerIdentifier: String = VaccineHeaderView().identifier
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    var headerHeight: CGFloat = 32
    
    
    var cellHeight: CGFloat = 250
    
    
    var items: [VaccineItem]
    
    typealias T = VaccineItem
    
        
    var title: String
    var itemClosure: ((VaccineItem) -> Void)?
    var headerClosure: ((VaccineSection) -> Void)?


}


struct ActionSection: Section {

    
    var cellIdentifier: String = ActivityTableViewCell().identifier
    
    var headerIdentifier: String = ActionHeaderView().identifier
    
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    
    var headerHeight: CGFloat = 32
    
    
    var cellHeight: CGFloat = 90
    
    
    var items: [Action]
    
    typealias T = Action
    
    
    var title: String
    
    var headerClosure: ((ActionSection) -> Void)?

    var itemClosure: ((Action) -> Void)?
    
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! ActionHeaderView
        header.setupHeader(title: title)
        header.buttonAction = {
            if let closure = headerClosure {
                closure(self)
            }
        }
        return header
    }
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ActivityTableViewCell
        let activity = items[indexPath.row]
        cell.setupAction(activity: activity, isFirst: indexPath.row == 0, isLast: indexPath.row == (items.count - 1))
        return cell
    }

}

struct ChildSection : Section {
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! ChildHeaderView
        header.titleLabel.text = title
        header.subtitleLabel.text = subtitle
        
        return header
    }
    
    var headerClosure: ((ChildSection) -> Void)?
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ChildTableViewCell
        let child = items[indexPath.row]
        
        cell.childImage.moa.url = child.photo
        
        
        cell.childImage.moa.onSuccess = { image in
            cell.imageLoadingIndicator.stopAnimating()
            cell.imageLoadingIndicator.fadeOut()
            cell.childImage.fadeIn()
            cell.setupChild(child: child)
            return image
        }
        return cell
    }
    
    var itemClosure: ((Child) -> Void)?
    
    var cellIdentifier: String = ChildTableViewCell().identifier
    
    var headerIdentifier: String = ChildHeaderView().identifier
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    
    var headerHeight: CGFloat = 0
    
    var cellHeight: CGFloat = 500

    var items: [Child]
    
    typealias T = Child
    
    
    var title: String
    var subtitle: String
    
}

struct DiaperSection : Section {
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DiaperTableViewCell
         
        cell.setupDiapers(diapers: items)
        
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier) as! DiaperHeaderView
        header.setupHeader(with: title)
        if let sectionClosure = headerClosure {
            header.headerAction = {
                sectionClosure(self)
            }
        }
        
        return header
    }
    

    func numberOfRows() -> Int {
        return 1
    }
    
    
    var headerHeight: CGFloat = 32
    
    
    var cellHeight: CGFloat = 200

    typealias T = Diaper
    
    var title: String
    var items: [Diaper]

    var cellIdentifier: String = DiaperTableViewCell().identifier
    
    var headerIdentifier: String = DiaperHeaderView().identifier
    
    var itemClosure: ((Diaper) -> Void)?
    
    var headerClosure: ((DiaperSection) -> Void)?
}
