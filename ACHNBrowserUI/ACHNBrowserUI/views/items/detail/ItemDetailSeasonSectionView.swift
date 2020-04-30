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
        Section(header: SectionHeaderView(text: "Seasonality")) {
            VStack(spacing: 8) {
                if item.formattedTimes() != nil {
                    HStack {
                        Spacer()
                        Image(systemName: "clock.fill").foregroundColor(.secondaryText)
                        Text("\(item.formattedTimes()!)")
                            .foregroundColor(.secondaryText)
                            .font(.body)
                        Spacer()
                    }.padding(.top, 4)
                }
                if item.activeMonths != nil {
                    HStack(alignment: .center) {
                        Spacer()
                        CalendarView(activeMonths: item.activeMonths!)
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
