//
//  ChartStatsUIView.swift
//  Nenis
//
//  Created by Caio Ferreira on 04/01/24.
//

import SwiftUI
import Charts

struct ChartStatsUIView: View {
    let chartGroups: [ChartGroup]
    var body: some View {
        Chart {
            ForEach(chartGroups, id: \.id) { group in
                    ForEach(group.data) { data in
                        
                        LineMark(
                            x: .value("name", data.title),
                            y: .value("value", data.value)
                        )
                        .foregroundStyle(Color(group.color))
                        .interpolationMethod(.cardinal)
                    }
            }
        }
      
    }
}

#Preview {
    
    ChartStatsUIView(
        chartGroups: [
            ChartGroup(
            title: "Test",
            color: UIColor.orange,
            tag: "Test1",
            data: [
                ChartData(title: "26/10",
                          value: 8.10),
                ChartData(title: "11/11",
                          value: 14.00)
            ]
        ),
            ChartGroup(
            title: "Test",
            color: UIColor.magenta,
            tag: "Test2",
            data: [
                ChartData(title: "26/10",
                          value: 12.10),
                ChartData(title: "11/11",
                          value: 17.00)
            ]
        ),
        ]
    )
}

struct ChartData : Identifiable {
    var id = UUID()
    let title: String
    let value: Double
}

struct ChartGroup: Identifiable  {
    var id = UUID()
    let title: String
    let color: UIColor
    let tag: String
    let data: [ChartData]
}
