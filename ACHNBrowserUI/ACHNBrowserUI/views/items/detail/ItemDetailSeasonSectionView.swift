//
//  ItemDetailSeasonView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 26/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ItemDetailSeasonSectionView: View {
    let item: Item
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Seasonality", icon: "cloud.sun.rain.fill")) {
            VStack(spacing: 8) {
                if item.formattedTimes() != nil {
                    HStack {
                        Spacer()
                        Image(systemName: "clock.fill").foregroundColor(.acSecondaryText)
                        Text("\(item.formattedTimes()!)")
                            .foregroundColor(.acSecondaryText)
                            .font(.body)
                        Spacer()
                    }.padding(.top, 4)
                }
                if item.activeMonthsCalendar != nil {
                    HStack(alignment: .center) {
                        Spacer()
                        CalendarView(activeMonths: item.activeMonthsCalendar!)
                        Spacer()
                    }
                }
            }
        }
    }
}

struct ItemDetailSeasonView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailSeasonSectionView(item: static_item)
    }
}
