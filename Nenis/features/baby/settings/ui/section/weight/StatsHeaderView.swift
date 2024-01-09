//
//  WeightHeaderView.swift
//  Nenis
//
//  Created by Caio Ferreira on 04/01/24.
//

import UIKit
import SwiftUI

class StatsHeaderView: UITableViewHeaderFooterView, CustomViewProtocol {
    
    static var viewType: ViewType = .header
    
    @IBOutlet weak var chartView: UIView!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        chartView.isHidden = true
    }
    
    func setupHeader(titleText: String?, subtitle: String?, stats: [ChartGroup]) {
        
        title.text = titleText
        title.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .black)
        caption.text = subtitle
        if(!stats.isEmpty) {
            createChart(charts: stats)
        }
    }

    func createChart(charts: [ChartGroup]) {
        if (!chartView.subviews.isEmpty) {
            chartView.subviews.forEach({
                $0.removeFromSuperview()
            })
        }
        let hostingView = _UIHostingView(
            rootView: ChartStatsUIView(chartGroups: charts)
        )
        hostingView.autoresizingMask = .flexibleWidth
        hostingView.frame = CGRectMake(0, 0, chartView.frame.size.width * 0.99, chartView.frame.size.height * 0.90);
        chartView.autoresizesSubviews = true
        chartView.addSubview(hostingView)

        chartView.layoutIfNeeded()
        chartView.fadeIn(500)
    }
}
