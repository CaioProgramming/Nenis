//
//  WeightSection.swift
//  Nenis
//
//  Created by Caio Ferreira on 03/01/24.
//

import Foundation
import UIKit

struct StatsDataSection: Section {
    var items: [UpdateData]
    
    var headerData: HeaderComponent?
    
    var footerData: FooterComponent?
    
    var caption: String?
    var metric: String
    var chartStyle: (String, UIColor)
    var cellHeight: CGFloat = 50
    
    var editingStyle: UITableViewCell.EditingStyle = .delete
    
    var itemClosure: ((UpdateData, UIView?) -> Void)
    
    var deleteClosure: ((UpdateData) -> Void)? = nil
    
    typealias T = UpdateData
    
    typealias H = StatsHeaderView
    
    typealias C = HorizontalTableViewCell
    
    typealias F = VerticalTableFooterView
    
    func dequeueHeader(with tableView: UITableView, sectionIndex: Int) -> StatsHeaderView {
        let header = H.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        let chartDatas = items.map({ data in
            ChartData(title: data.date.formatted(date: .numeric, time: .omitted), value: data.value)
        })
        header.setupHeader(titleText: headerData?.title,
                           subtitle: caption,
                           stats: [
                                ChartGroup(
                                    title: chartStyle.0,
                                    color: chartStyle.1,
                                    tag: chartStyle.0,
                                    data: chartDatas.reversed()
                                )
                          ]
         )
        return header
    }
    
    func dequeueFooter(with tableView: UITableView, sectionIndex: Int) -> VerticalTableFooterView {
        let f = F.dequeueHeaderOrFooter(with: tableView, sectionIndex: sectionIndex)
        f.setupView(info: footerData)
        f.footerButton.configuration = UIButton.Configuration.plain()
        return f
    }
    
    func dequeueCell(with tableView: UITableView, indexPath: IndexPath) -> HorizontalTableViewCell {
        let item = items[indexPath.row]
        let c = C.dequeueTableViewCell(with: tableView, indexPath: indexPath)
        c.setupData(field: "\(item.value.twoPointsFormat())\(metric)", value: nil, subtitle: "\(item.date.formatted(date: .abbreviated, time: .omitted))", isFirst: item == items.first, isLast: item == items.last)
        return c
    }
    
    func headerHeight() -> CGFloat {
        return 300
    }
}
