//
//  TodayTurnipSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend

struct TodayTurnipSection: View {
    @Environment(\.currentDate) private var currentDate
    @EnvironmentObject private var turnipService: TurnipPredictionsService
    
    var isSunday: Bool {
        Calendar.current.component(.weekday, from: currentDate) == 1
    }
    
    var body: some View {
        HStack {
            Image("icon-turnip")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 33)
            Group {
                if isSunday {
                    Text("Today is sunday, don't forget to buy more turnips and fill your buy price.")
                } else if turnipService.predictions?.todayAverages == nil || turnipService.predictions?.todayAverages?.isEmpty == true {
                    Text("Your turnips predictions will be displayed here once you fill in some prices.")
                }  else {
                    Text("Today's average price should be around ")
                        + Text("\(turnipService.predictions!.todayAverages![0])")
                        .foregroundColor(.acSecondaryText)
                        + Text(" in the morning, and ")
                        + Text("\(turnipService.predictions!.todayAverages![1])")
                        .foregroundColor(.acSecondaryText)
                        + Text(" this afternoon.")
                }
            }
            .font(.system(.body, design: .rounded))
            .foregroundColor(.acText)
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

struct TodayTurnipSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTurnipSection()
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
