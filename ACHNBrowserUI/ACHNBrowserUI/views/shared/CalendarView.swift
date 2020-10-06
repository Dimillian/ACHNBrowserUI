//
//  CalendarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CalendarView: View {
    @Environment(\.currentDate) private var currentDate
    let activeMonths: [Int]

    private let months = [[Calendar.current.shortMonthSymbols[0],
                           Calendar.current.shortMonthSymbols[1],
                           Calendar.current.shortMonthSymbols[2],
                           Calendar.current.shortMonthSymbols[3]],
                          [Calendar.current.shortMonthSymbols[4],
                           Calendar.current.shortMonthSymbols[5],
                           Calendar.current.shortMonthSymbols[6],
                           Calendar.current.shortMonthSymbols[7]],
                          [Calendar.current.shortMonthSymbols[8],
                           Calendar.current.shortMonthSymbols[9],
                           Calendar.current.shortMonthSymbols[10],
                           Calendar.current.shortMonthSymbols[11]]]
    
    var flatMonths: [String] {
        months.flatMap{ $0.compactMap{ $0 }}
    }

    private func makeMonthPill(month: String, selected: Bool) -> some View {
        let monthsArray = months.flatMap({ $0 })
        let currentMonth = Int(Item.monthFormatter.string(from: currentDate))!
        let isCurrentMonth = monthsArray.firstIndex(of: month) == currentMonth - 1
        let border =  RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: isCurrentMonth ? 5 : 0)
            .foregroundColor(isCurrentMonth ? .acTabBarTint : .clear)
        return Text(month)
            .font(.callout)
            .foregroundColor(.black)
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
                                           selected: self.activeMonths
                                            .contains(self.flatMonths.firstIndex(of: month)!))
                    }
                }
            }
        }.padding(24)
            .background(Color.catalogBackground)
            .cornerRadius(30)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView(activeMonths: [1, 3])
    }
}
