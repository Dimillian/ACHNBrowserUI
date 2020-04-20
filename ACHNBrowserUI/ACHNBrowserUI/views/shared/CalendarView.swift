//
//  CalendarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CalendarView: View {
    let selectedMonths: [String]
    
    private let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
    private let months = [["jan", "feb", "mar", "apr"],
                          ["may", "jun", "jul", "aug"],
                          ["sep","oct", "nov", "dec"]]

    private func makeMonthPill(month: String, selected: Bool) -> some View {
        let monthsArray = months.flatMap({ $0 })
        let isCurrentMonth = monthsArray.firstIndex(of: month) == currentMonth - 1
        let border =  RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: isCurrentMonth ? 5 : 0)
            .foregroundColor(isCurrentMonth ? .grass : .clear)
        return Text(month.capitalized)
            .font(.callout)
            .frame(width: 50, height: 30)
            .overlay(border)
            .background(selected ? Color.catalogSelected : Color.catalogBar)
        .cornerRadius(10)
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(months, id: \.self) { group in
                HStack(spacing: 8) {
                    ForEach(group, id: \.self) { month in
                        self.makeMonthPill(month: month,
                                           selected: self.selectedMonths.contains(month))
                    }
                }
            }
        }
        .padding(24)
        .background(Color.catalogBackground)
        .cornerRadius(30)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(selectedMonths: ["jan", "feb"])
    }
}
