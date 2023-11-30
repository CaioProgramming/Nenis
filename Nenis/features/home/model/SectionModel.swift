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
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage? , closure: () -> Void)? { get }
    var footerData: (message: String,actionTitle: String, closure: () -> Void)? { get }
    var cellHeight: CGFloat { get }
    func numberOfRows() -> Int
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F
    var itemClosure: ((T) -> Void) { get }
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
        var size: CGFloat = 0
        
        if(footerData != nil) {
            size = 75
        }
        print("Footer for \(String(describing: type(of: self))) height will be -> \(size)")
        
        return size
    }
    
    func headerHeight() -> CGFloat {
        var size: CGFloat = 75
        
        if(headerData == nil) {
            size = 0
        }
        print("Header for \(String(describing: type(of: self))) height will be -> \(size)")
        return size
    }
    
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func performItemClosure(index: Int) {
        let item = items[index]
        itemClosure(item)
    }
}

protocol SectionsProtocol {
    func requestNewAction()
    func openVaccines()
    func openDiapers()
    
}

//MARK: - Vaccine Section
struct VaccineSection: Section {
    
    typealias T = VaccineItem
    
    var items: [VaccineItem]

    var itemClosure: ((VaccineItem) -> Void)
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?
    var footerData: (message: String, actionTitle: String, closure: () -> Void)?

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
        header.newActionButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        return header
    }
    
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        cell.updateVaccines(vaccineList: items)
        
        cell.selectVaccine = { item in
            itemClosure(item)
        }
        return cell
    }
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    let cellHeight: CGFloat = 250
    
    
    func footerHeight() -> CGFloat {
        return 0
    }
    
    func headerHeight() -> CGFloat {
        return 50
    }
    
    
    

    
}


struct ActionSection: Section {
    
    let cellHeight: CGFloat = 90
    typealias T = Action
    typealias H = HorizontalHeaderView
    typealias C = ActivityTableViewCell
    typealias F = VerticalTableFooterView
    
    var items: [Action]
    var itemClosure: ((Action) -> Void)
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?
    var footerData: (message: String, actionTitle: String, closure: () -> Void)?

    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        footer.setupView(info: footerData)
        footer.isHidden = !items.isEmpty
        return footer
    }
    

    func numberOfRows() -> Int {
        return items.count
    }
    


    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.setupHeader(info: headerData)
        return header
    }
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        let activity = items[indexPath.row]
        cell.setupAction(activity: activity, isFirst: indexPath.row == 0, isLast: indexPath.row == (items.count - 1))
        return cell
    }
    
}

//MARK: - CHILD SECTION
struct ChildSection : Section {

    
    var title: String
    var subtitle: String
    var items: [Child]
    var itemClosure: ((Child) -> Void)
    
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?
    var footerData: (message: String, actionTitle: String, closure: () -> Void)?

 
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
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
        cell.childClosure = {
            self.itemClosure(child)
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
    
    
    var cellHeight: CGFloat = 420
    
    func headerHeight() -> CGFloat {
        return if(title.isEmpty && subtitle.isEmpty) { 0 } else { 75 }
    }
    
    func footerHeight() -> CGFloat {
        return 0
    }
    
    
    typealias T = Child
    
    

    
    
}
// MARK: -

// MARK: Diaper Section
struct DiaperSection : Section {
    
    
    var items: [Diaper]
    
    var itemClosure: ((Diaper) -> Void)
        
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?
    var footerData: (message: String, actionTitle: String, closure: () -> Void)?

    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: footerData)
        footer.isHidden = !items.isEmpty
        return footer
    }
    
    
    typealias H = HorizontalHeaderView
    
    typealias C = DiaperTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let cell = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupDiapers(diapers: items)
        
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        header.setupHeader(info: headerData)
        return header
    }
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    var cellHeight: CGFloat = 225
    
    
    typealias T = Diaper
    

    
}

struct OptionSection : Section {
    
    
    var items: [Option]
    var itemClosure: ((Option) -> Void)
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?
    var footerData: (message: String, actionTitle: String, closure: () -> Void)?

    typealias T = Option
    
    typealias H = HorizontalHeaderView
    
    typealias C = OptionTableViewCell
    
    typealias F = VerticalTableFooterView
    
        
    let cellHeight: CGFloat = 50
 
    
    func headerHeight() -> CGFloat {
        return 0
    }
    
    func footerHeight() -> CGFloat {
        return 70
    }
    
    func numberOfRows() -> Int {
        return items.count
    }
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> C {
        let option = items[indexPath.row]
        let cell = C.dequeueView(with: tableView, indexPath: indexPath)
        let position : PositionType = if(indexPath.row == items.startIndex) { PositionType.first } else if(indexPath.row == items.count - 1) { PositionType.last } else { PositionType.none }
        cell.setupButton(option: option, positionType: position)
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> H {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        return header
    }
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> F {
        let footer = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        footer.setupView(info: self.footerData)
        footer.footerButton.tintColor = UIColor.red
        footer.footerLabel.font = footer.footerLabel.font.withSize(UIFont.smallSystemFontSize)
        return footer
    }
    
 
    
    
}

struct SettingsDetailsSection: Section {
    var items: [DetailModel]
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> HorizontalTableViewCell {
        let item = items[indexPath.row]
        let cell = HorizontalTableViewCell.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        cell.setupData(field: item.name, value: item.value)
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
        return footer
    }
    
    var itemClosure: ((DetailModel) -> Void)
    
    typealias T = DetailModel
    
    typealias H = HorizontalHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = VerticalTableFooterView
    
 
    var headerData: (title: String, actionTitle: String, uiIcon: UIImage?, closure: () -> Void)?
    var footerData: (message: String, actionTitle: String, closure: () -> Void)?
    let cellHeight: CGFloat = 64
    
    
}

 
