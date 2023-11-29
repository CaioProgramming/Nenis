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
    var title: String { get }
    var footerMessage: (String, String)? { get }
    var cellHeight: CGFloat { get }
    func numberOfRows() -> Int
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> UIView
    var itemClosure: ((T) -> Void)? { get }
    var headerClosure: ((Self) -> Void)? { get }
    var footerClosure: ((Self) -> Void)? { get }
    func footerHeight() -> CGFloat
    func headerHeight() -> CGFloat
   

}

extension Section {
    func footerHeight() -> CGFloat {
        var size: CGFloat = 0
        
        if(items.isEmpty) {
            size = 100
        }
        print("Footer for \(String(describing: type(of: self))) height will be -> \(size)")

        return size
    }
    
    func headerHeight() -> CGFloat {
        var size: CGFloat = 75
        
        if(items.isEmpty) {
            size = 0
        }
        print("Header for \(String(describing: type(of: self))) height will be -> \(size)")
        return size
    }
}

protocol SectionsProtocol {
    func requestNewAction()
    func openVaccines()
    func openDiapers()
    
}

//MARK: - Vaccine Section
struct VaccineSection: Section {
    
    var footerClosure: ((VaccineSection) -> Void)?
    
    
    var footerMessage: (String, String)? = nil
    
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        if let message = footerMessage {
            footer.setupView(info: message, closure: { })
        }
        return footer
    }
    
    
 
    typealias H = HorizontalHeaderView
    
    typealias C = VaccineTableViewCell
    
    typealias F = VerticalTableFooterView
    

    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.setupHeader(title: title, buttonInfo: ("Ver todas", "chevron.right", {
            if let headClosure = headerClosure {
                headClosure(self)
            }
        }))
        header.container.isHidden = items.isEmpty
        return header
    }
    
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        cell.updateVaccines(vaccineList: items)
        cell.selectVaccine = { item in
            if let closure = itemClosure {
                closure(item)
            }
        }
        return cell
    }
    
    
    func numberOfRows() -> Int {
        return 1
    }
    
    
    var cellHeight: CGFloat = 250
    
   
    func footerHeight() -> CGFloat {
        return 0
    }
    
    func headerHeight() -> CGFloat {
        return 50
    }
    
    
    var items: [VaccineItem]
    
    typealias T = VaccineItem
    
        
    var title: String
    var itemClosure: ((VaccineItem) -> Void)?
    var headerClosure: ((VaccineSection) -> Void)?


}


struct ActionSection: Section {
    
    var footerMessage: (String, String)? = ("Parece que você nao salvou nenhuma atividade", "Adicionar atividades")
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        if let message = footerMessage {
            footer.setupView(info: message, closure: {
                if let sectionFooterClosure = footerClosure {
                    sectionFooterClosure(self)
                }
            })
            footer.footerContainer.isHidden = !items.isEmpty
        }
        return footer
    }
    
    
    typealias H = HorizontalHeaderView
    
    typealias C = ActivityTableViewCell
    
    typealias F = VerticalTableFooterView
    


    func numberOfRows() -> Int {
        return items.count
    }
    
    var cellHeight: CGFloat = 90
    
    
    var items: [Action]
    
    typealias T = Action
    
    
    var title: String
    
    var headerClosure: ((ActionSection) -> Void)?

    var itemClosure: ((Action) -> Void)?
    
    var footerClosure: ((ActionSection) -> Void)?

    
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.setupHeader(title: title, buttonInfo: ("", "plus.circle.fill", {
            if let closure = headerClosure {
                closure(self)
            }
        }))
        header.container.isHidden = items.isEmpty
        return header
    }
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        let activity = items[indexPath.row]
        cell.setupAction(activity: activity, isFirst: indexPath.row == 0, isLast: indexPath.row == (items.count - 1))
        return cell
    }

}

//MARK: - CHILD SECTION
struct ChildSection : Section {
    
    
    var footerMessage: (String, String)? = nil
    
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        return footer
    }
    
    
    typealias H = ChildHeaderView
    
    typealias C = ChildTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.titleLabel.text = title
        header.subtitleLabel.text = subtitle.capitalized
        
        return header
    }
    
    var headerClosure: ((ChildSection) -> Void)?
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
        let child = items[indexPath.row]
        
        cell.childImage.moa.url = child.photo
        
        
        cell.childImage.moa.onSuccess = { image in
           
            cell.childImage.fadeIn()
            cell.setupChild(child: child)
     
            return image
        }
        return cell
    }
    
    var itemClosure: ((Child) -> Void)?
    
    var footerClosure: ((ChildSection) -> Void)?

    
    func numberOfRows() -> Int {
        return 1
    }
    
 
    var cellHeight: CGFloat = 300
    
    func headerHeight() -> CGFloat {
        return 100
    }
    
    func footerHeight() -> CGFloat {
        return 0
    }

    var items: [Child]
    
    typealias T = Child
    
    
    var title: String
    var subtitle: String
    
}
// MARK: -

// MARK: Diaper Section
struct DiaperSection : Section {
    
    var footerMessage: (String, String)? = ("Você ainda nao adicionou nenhuma fralda, adicione para acompanhar seu bebe", "Adicionar fraldas")
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: F.identifier) as! F
        if let message = footerMessage {
            footer.setupView(info: message, closure: {
                if let sectionFooterClosure = footerClosure {
                    sectionFooterClosure(self)
                }
            })
            footer.footerContainer.isHidden = !items.isEmpty
        }
        return footer
    }
    
 
    typealias H = HorizontalHeaderView
    
    typealias C = DiaperTableViewCell
    
    typealias F = VerticalTableFooterView
    
    
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as! C
         
        cell.setupDiapers(diapers: items)
        
        return cell
    }
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> UIView {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: H.identifier) as! H
        header.setupHeader(title: title, buttonInfo: ("Ver todas as fraldas", "chevron.right", {
            if let sectionClosure = headerClosure {sectionClosure(self)}
        }))
        header.container.isHidden = items.isEmpty

        return header
    }
    

    func numberOfRows() -> Int {
        return 1
    }
    
    
    var cellHeight: CGFloat = 170
    

    typealias T = Diaper
    
    var title: String
    var items: [Diaper]
    
    var itemClosure: ((Diaper) -> Void)?
    
    var headerClosure: ((DiaperSection) -> Void)?
    
    var footerClosure: ((DiaperSection) -> Void)?

}
