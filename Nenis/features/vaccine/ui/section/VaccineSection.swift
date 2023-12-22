//
//  VaccineSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 05/12/23.
//

import Foundation
import UIKit
struct VaccineSection: Section {
    
  
    
    
    typealias T = VaccineItem
    
    var items: [VaccineItem]

    var itemClosure: ((VaccineItem, UIView?) -> Void)
    var eventRequest: ((VaccineItem ) -> Void)
    
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .none

    typealias H = HorizontalHeaderView
    
    typealias C = VaccineTableViewCell
    
    typealias F = VerticalTableFooterView
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        footer.setupView(info: footerData)
        return footer
    }
    

    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.setupHeader(info: headerData)
        header.mainContainerView.backgroundColor = UIColor.clear
        return header
    }
    
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        cell.updateVaccines(vaccineList: items)
        
        cell.selectVaccine = { (item, action) in
            if(action == .open) {
                itemClosure(item, nil)

            } else {
                eventRequest(item)
            }
        }
        return cell
    }
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    let cellHeight: CGFloat = 200
    
    
    func footerHeight() -> CGFloat {
        return 0
    }
    
    func headerHeight() -> CGFloat {
        return 50
    }
    
    
    

    
}

struct VaccineSettingsSection: Section {

    
    var items: [VaccineItem]
    var itemClosure: ((VaccineItem, UIView?) -> Void)
    var headerData: HeaderComponent?
    var footerData: FooterComponent?
    var editingStyle: UITableViewCell.EditingStyle = .none

    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> VaccineHorizontalTableViewCell {
        let vaccine = items[indexPath.row]
        let cell = VaccineHorizontalTableViewCell.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupItem(title: vaccine.vaccine.title, subtitle: " \(vaccine.nextDose) de \(vaccine.vaccine.periods.count) doses", icon: vaccine.status.icon, iconColor: vaccine.status.color)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> HorizontalHeaderView {
        let header = HorizontalHeaderView.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)
        return header
    }
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> VerticalTableFooterView {
        let footer = VerticalTableFooterView.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
        footer.footerButton.tintColor = UIColor.red.withAlphaComponent(0.6)
        footer.footerButton.isHidden = sectionIndex == 0
        return footer
    }
    
    
    typealias T = VaccineItem
    
    typealias H = HorizontalHeaderView
    
    typealias C = VaccineHorizontalTableViewCell
    
    typealias F = VerticalTableFooterView
    
    var cellHeight: CGFloat = 75
    
    
}

struct VaccineCollectionSection: Section {
    var items: [VaccineItem]
    
    var itemClosure: ((VaccineItem, UIView?) -> Void)
    
    typealias T = VaccineItem
    
    typealias H = HorizontalHeaderView
    
    typealias C = VaccineVerticalViewCell
    
    typealias F = VaccineFooterView
    
    var headerData: HeaderComponent?
    
    var footerData: FooterComponent?
    
    var cellHeight: CGFloat
    
    var editingStyle: UITableViewCell.EditingStyle
    
    func dequeueCollectionCell(with collectionView: UICollectionView, indexpath: IndexPath) -> VaccineVerticalViewCell {
        let item = items[indexpath.row]
        let cell = C.dequeueCollectionCell(collectionView, cellForItemAt: indexpath)
        cell.setupVaccine(label: item.vaccine.description, vaccine: item.vaccine.title, progress: item.doseProgress, nextDate: item.formatNextDate(), status: item.status)
        return cell
    }
    
}
