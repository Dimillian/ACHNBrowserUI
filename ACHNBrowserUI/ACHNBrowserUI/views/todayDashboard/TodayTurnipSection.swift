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
    let predictions: TurnipPredictions?
    
    var body: some View {
        // MARK: - Turnip Card
        Section(header: SectionHeaderView(text: "Turnips", icon: "dollarsign.circle.fill")) {
            HStack {
                Image("icon-turnip")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 33)
                Group {
                    if predictions?.todayAverages?.isEmpty == true {
                        Text("Today is sunday, don't forget to buy more turnips and fill your buy price")
                    } else {
                        Text("Today's average price should be around ")
                            + Text("\(predictions!.todayAverages![0])")
                                .foregroundColor(Color("ACSecondaryText"))
                            + Text(" in the morning, and ")
                            + Text("\(predictions!.todayAverages![1])")
                                .foregroundColor(Color("ACSecondaryText"))
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
}

struct TodayTurnipSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTurnipSection(predictions: TurnipsPredictionService.shared.predictions)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
