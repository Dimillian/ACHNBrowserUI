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
    let todaysEntries: [String]?
    
    var isSunday: Bool {
        Calendar.current.component(.weekday, from: Date()) == 1
    }
    
    var body: some View {
        // MARK: - Turnip Card
        Section(header: SectionHeaderView(text: "Turnips", icon: "dollarsign.circle.fill")) {
            HStack {
                Image("icon-turnip")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: 33)
                Group {
                    if isSunday {
                        Text("Today is sunday, don't forget to buy more turnips and fill your buy price.")
                    } else if predictions?.todayAverages == nil || predictions?.todayAverages?.isEmpty == true {
                        Text("Your turnips predictions will be displayed here once you fill in some prices.")
                    }  else if todaysEntries == nil{
                        allAverage
                    } else {
                        if todaysEntries![0].isEmpty == true && todaysEntries![1].isEmpty == true{
                            allAverage
                        } else if todaysEntries![0].isEmpty == false && todaysEntries![1].isEmpty == true{
                            eveningAverage
                        } else if todaysEntries![0].isEmpty == true && todaysEntries![1].isEmpty == false{
                            morningAverage
                        } else {
                            allPrices
                        }
                    }
                }
                .font(.system(.body, design: .rounded))
                .foregroundColor(.acText)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    private var allAverage: some View {
        Text("Today's average price should be around ")
            + Text("\(predictions!.todayAverages![0])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(" in the morning, and ")
            + Text("\(predictions!.todayAverages![1])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(" this afternoon.")
    }
    private var morningAverage: some View {
        Text("Today's morning average price should be around ")
            + Text("\(predictions!.todayAverages![0])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(", and your afternoon price is ")
            + Text("\(todaysEntries![1])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(" this afternoon.")
    }
    private var eveningAverage: some View {
        Text("Today's morning price is ")
            + Text("\(todaysEntries![0])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(", and the afternoon average price should be around ")
            + Text("\(predictions!.todayAverages![1])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(".")
    }
    private var allPrices: some View {
        Text("Today's morning price is ")
            + Text("\(todaysEntries![0])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(", and the afternoon price is ")
            + Text("\(predictions!.todayAverages![1])")
                .foregroundColor(Color("ACSecondaryText"))
            + Text(".")
    }
}

struct TodayTurnipSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTurnipSection(predictions: TurnipPredictionsService.shared.predictions, todaysEntries: TurnipPredictionsService.shared.fields?.todaySell)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
