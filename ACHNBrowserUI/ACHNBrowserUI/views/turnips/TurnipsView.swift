//
//  TurnipView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct TurnipsView: View {
    // MARK: - Vars
    private enum TurnipsDisplay: String, CaseIterable {
        case minMax, average, profits, chart
        
        func title() -> String {
            switch self {
            case .average: return "Average daily buy prices"
            case .minMax: return "Daily min-max prices"
            case .profits: return "Average profits"
            case .chart: return "Chart"
            }
        }

        var isChart: Bool {
            get { self == .chart }
            set { }
        }
    }
    
    @EnvironmentObject private var turnipService: TurnipPredictionsService
    @EnvironmentObject private var subManager: SubscriptionManager
    @ObservedObject private var viewModel = TurnipsViewModel()
    @State private var presentedSheet: Sheet.SheetType?
    @State private var turnipsDisplay: TurnipsDisplay = .minMax
    @State private var enableTurnipsExchange = false
    
    private let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                TurnipsFormView().environmentObject(subManager)
            }
            List {
                if subManager.subscriptionStatus == .notSubscribed {
                    subscriptionSection
                }
                if UIDevice.current.userInterfaceIdiom != .pad ||
                    (UIDevice.current.orientation == .portrait ||
                        UIDevice.current.orientation == .portraitUpsideDown){
                    Section(header: SectionHeaderView(text: "Your prices", icon: "pencil")) {
                        Button(action: {
                            self.presentedSheet = .turnipsForm(subManager: self.subManager)
                        }) {
                            Text(TurnipFields.exist() ? "Edit your in game prices" : "Add your in game prices")
                                .foregroundColor(.acHeaderBackground)
                        }
                    }
                }
                predictionsSection
                if turnipService.turnipProhetUrl != nil {
                    prophetSection
                }
                exchangeSection
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Turnips",
                                displayMode: .automatic)
            .navigationBarItems(trailing: shareButton)
            .sheet(item: $presentedSheet, content: {
                Sheet(sheetType: $0)
            })
        }
        .onAppear(perform: NotificationManager.shared.registerForNotifications)
        .onAppear {
            if self.enableTurnipsExchange {
                self.viewModel.fetchIslands()
            }
        }
    }
}

// MARK: - Views
extension TurnipsView {
    private var shareButton: some View {
        Button(action: {
            let image = NavigationView {
                List {
                    self.predictionsSection
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(width: 350, height: 650).asImage()
            self.presentedSheet = .share(content: [ItemDetailSource(name: "Turnips prediction", image: image)])
        }) {
            Image(systemName: "square.and.arrow.up")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var subscriptionSection: some View {
        Section(header: SectionHeaderView(text: "AC Helper+", icon: "heart.fill")) {
            VStack(spacing: 8) {
                Button(action: {
                    self.presentedSheet = .subscription(source: .turnip, subManager: self.subManager)
                }) {
                    Text("To help us support the application and get turnip predictions notification, you can try out AC Helper+")
                        .foregroundColor(.acSecondaryText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                }
                Button(action: {
                    self.presentedSheet = .subscription(source: .turnip, subManager: self.subManager)
                }) {
                    Text("Learn more...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.buttonStyle(PlainRoundedButton())
                    .accentColor(.acHeaderBackground)
                    .padding(.bottom, 8)
            }
        }
    }
    
    private var predictionsSection: some View {
        Section(header: SectionHeaderView(text: turnipsDisplay.title(), icon: "dollarsign.circle.fill"),
                footer: Text(viewModel.pendingNotifications == 0 ? "" :
                    "\(viewModel.pendingNotifications - 1) upcomingDailyNotifications")
                    .font(.footnote)
                    .foregroundColor(.catalogUnselected)
                    .lineLimit(nil)) {
            if viewModel.averagesPrices != nil && viewModel.minMaxPrices != nil {
                Picker(selection: $turnipsDisplay, label: Text("")) {
                    ForEach(TurnipsDisplay.allCases, id: \.self) { section in
                        Text(LocalizedStringKey(section.rawValue.capitalized))
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                if turnipsDisplay != .chart {
                    if turnipsDisplay == .profits && viewModel.averagesProfits != nil {
                        Text("Profits estimates are computed using the average of the current period")
                            .foregroundColor(.acSecondaryText)
                    }
                    GridStack<AnyView>(rows: 1, columns: 3) { _, column in
                        switch column {
                        case 0: return Text("Day").fontWeight(.bold).eraseToAnyView()
                        case 1: return Text("AM").fontWeight(.bold).eraseToAnyView()
                        case 2: return Text("PM").fontWeight(.bold).eraseToAnyView()
                        default: return EmptyView().eraseToAnyView()
                        }
                    }
                }
                if turnipsDisplay == .average {
                    GridStack(rows: labels.count, columns: 3, spacing: 16, content: averageGridValues)
                }
                else if turnipsDisplay == .minMax {
                    GridStack(rows: labels.count, columns: 3, spacing: 16, content: minMaxGridValues)
                } else if turnipsDisplay == .profits {
                    if viewModel.averagesProfits != nil {
                        GridStack(rows: labels.count, columns: 3, spacing: 16, content: averageProfitGridValues)
                    } else {
                        Text("Please add the amount of turnips you bought and for how much")
                            .foregroundColor(.acHeaderBackground)
                            .onTapGesture {
                                self.presentedSheet = .turnipsForm(subManager: self.subManager)
                        }
                    }
                } else if turnipsDisplay == .chart {
                    if viewModel.predictions != nil {
                        TurnipsChartView(
                            predictions: viewModel.predictions!,
                            animateCurves: $turnipsDisplay.isChart
                        ).padding(.top, 8)
                    } else {
                        Text("Add your in game turnip prices to see the predictions chart")
                            .foregroundColor(.acHeaderBackground)
                            .onTapGesture {
                                self.presentedSheet = .turnipsForm(subManager: self.subManager)
                        }
                    }
                }
            } else {
                Text("Add your in game turnip prices to see predictions")
                    .foregroundColor(.acHeaderBackground)
                    .onTapGesture {
                        self.presentedSheet = .turnipsForm(subManager: self.subManager)
                }
            }
        }
    }
    
    private var prophetSection: some View {
        Section(header: SectionHeaderView(text: "Services", icon: "link.icloud")) {
            Button(action: {
                if let url = self.turnipService.turnipProhetUrl {
                    self.presentedSheet = .safari(url)
                }
            }) {
                Text("View on TurnipProphet").foregroundColor(.acHeaderBackground)
            }
        }
    }
    
    private var exchangeSection: some View {
        Section(header: SectionHeaderView(text: "Turnip.Exchange", icon: "bitcoinsign.circle.fill")) {
            if enableTurnipsExchange {
                if viewModel.islands?.isEmpty == false {
                    viewModel.islands.map {
                        ForEach($0) { island in
                            NavigationLink(destination: IslandDetailView(island: island)) {
                                TurnipIslandRow(island: island)
                            }
                        }
                    }
                } else {
                    RowLoadingView(isLoading: .constant(true))
                }
            } else {
                Button(action: {
                    self.enableTurnipsExchange = true
                    self.viewModel.fetchIslands()
                }) {
                    Text("View Turnip.Exchange islands")
                        .foregroundColor(.acHeaderBackground)
                }
            }
        }
    }
}

extension TurnipsView {
    private enum Meridian { case am, pm }

    private func gridHeader(column: Int) -> some View {
        switch column {
        case 0: return Text("Day").fontWeight(.bold)
        case 1: return Text("AM").fontWeight(.bold)
        case 2: return Text("PM").fontWeight(.bold)
        default: return Text("").fontWeight(.bold)
        }
    }

    private func weekDaysText(row: Int) -> some View {
        Text(LocalizedStringKey(labels[row]))
            .font(.body)
            .foregroundColor(.acText)
            .eraseToAnyView()
    }

    private func averageGridValues(row: Int, column: Int) -> some View {
        switch column {
        case 0: return weekDaysText(row: row).eraseToAnyView()
        case 1: return averagePriceText(dayNumber: row, meridian: .am).eraseToAnyView()
        case 2: return averagePriceText(dayNumber: row, meridian: .pm).eraseToAnyView()
        default: return EmptyView().eraseToAnyView()
        }
    }

    private func minMaxGridValues(row: Int, column: Int) -> some View {
        switch column {
        case 0: return weekDaysText(row: row).eraseToAnyView()
        case 1: return minMaxPriceText(dayNumber: row, meridian: .am).eraseToAnyView()
        case 2: return minMaxPriceText(dayNumber: row, meridian: .pm).eraseToAnyView()
        default: return EmptyView().eraseToAnyView()
        }
    }

    private func averageProfitGridValues(row: Int, column: Int) -> some View {
        switch column {
        case 0: return weekDaysText(row: row).eraseToAnyView()
        case 1: return averageProfitText(dayNumber: row, meridian: .am).eraseToAnyView()
        case 2: return averageProfitText(dayNumber: row, meridian: .pm).eraseToAnyView()
        default: return EmptyView().eraseToAnyView()
        }
    }

    private func averagePriceText(dayNumber: Int, meridian: Meridian) -> some View {
        guard let averagePrices = viewModel.averagesPrices?[dayNumber],
            let averagePrice = meridian == .am ? averagePrices.first : averagePrices.last,
            let minMaxPricesForTheDay = viewModel.minMaxPrices?[dayNumber],
            let minMaxPrices = meridian == .am ? minMaxPricesForTheDay.first : minMaxPricesForTheDay.last else {
                return EmptyView().eraseToAnyView()
        }

        return Text("\(averagePrice)")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(color(averagePrice: averagePrice, minMaxPrices: minMaxPrices))
            .eraseToAnyView()
    }

    private func minMaxPriceText(dayNumber: Int, meridian: Meridian) -> some View {
        guard let averagePrices = viewModel.averagesPrices?[dayNumber],
            let averagePrice = meridian == .am ? averagePrices.first : averagePrices.last,
            let minMaxPricesForTheDay = viewModel.minMaxPrices?[dayNumber],
            let minMaxPrices = meridian == .am ? minMaxPricesForTheDay.first : minMaxPricesForTheDay.last else {
                return EmptyView().eraseToAnyView()
        }

        let isEntered = averagePrice == minMaxPrices.first && averagePrice == minMaxPrices.last
        let minMaxText: String
        if isEntered {
            minMaxText = "\(minMaxPrices.first ?? 0)"
        } else {
            minMaxText = minMaxPrices.map(String.init).joined(separator: " - ")
        }

        return Text(minMaxText)
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(color(averagePrice: averagePrice, minMaxPrices: minMaxPrices))
            .eraseToAnyView()
    }

    private func averageProfitText(dayNumber: Int, meridian: Meridian) -> some View {
        guard let averageProfitsPrices = viewModel.averagesProfits?[dayNumber],
            let averageProfitsPrice = meridian == .am ? averageProfitsPrices.first : averageProfitsPrices.last else {
                return EmptyView().eraseToAnyView()
        }

        return Text("\(averageProfitsPrice)")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(color(averagePrice: averageProfitsPrice, minMaxPrices: []))
            .eraseToAnyView()
    }

    private func color(averagePrice: Int, minMaxPrices: [Int]) -> Color {
        let isEntered = averagePrice == minMaxPrices.first && averagePrice == minMaxPrices.last
        let price = turnipsDisplay == .minMax ? Int(minMaxPrices.average) : averagePrice

        return isEntered ? .acText : color(price: price)
    }

    private func color(price: Int) -> Color {
        if price <= 90 {
            return .red
        } else if price >= 150 {
            return .acTabBarBackground
        } else {
            return .acSecondaryText
        }
    }
}

struct TurnipsView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsView()
            .environmentObject(SubscriptionManager.shared)
    }
}
