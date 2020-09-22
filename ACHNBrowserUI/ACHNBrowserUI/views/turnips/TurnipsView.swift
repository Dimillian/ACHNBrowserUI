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
    
    private let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Group {
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
                }.listRowBackground(Color.acSecondaryBackground)
            }
            .listStyle(InsetGroupedListStyle())
            .animation(.interactiveSpring())
            .navigationBarTitle("Turnips",
                                displayMode: .automatic)
            .navigationBarItems(trailing: shareButton)
            .sheet(item: $presentedSheet, content: {
                Sheet(sheetType: $0)
            })
        }
        .onAppear(perform: NotificationManager.shared.registerForNotifications)
        .navigationViewStyle(StackNavigationViewStyle())
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
            .listStyle(InsetGroupedListStyle())
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
    
    private var predictionSelectorView: some View {
        Picker(selection: $turnipsDisplay, label: Text("")) {
            ForEach(TurnipsDisplay.allCases, id: \.self) { section in
                Text(LocalizedStringKey(section.rawValue.capitalized))
            }
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private var predictionFooterView: some View {
        Text(viewModel.pendingNotifications == 0 ? "" :
                "\(viewModel.pendingNotifications - 1) upcomingDailyNotifications")
            .font(.footnote)
            .foregroundColor(.catalogUnselected)
            .lineLimit(nil)
    }
    
    @ViewBuilder
    private var predictionHeaderView: some View {
        if turnipsDisplay == .profits && viewModel.averagesProfits != nil {
            Text("Profits estimates are computed using the average of the current period")
                .foregroundColor(.acSecondaryText)
        }
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)), count: 3),
                  alignment: .center) {
            ForEach(["Day", "AM", "PM"], id: \.self) { label in
                HStack {
                    Text(LocalizedStringKey(label)).fontWeight(.bold)
                    if label == "Day" {
                        Spacer()
                    }
                }
            }
        }
    }
    
    private var predictionsSection: some View {
        Section(header: SectionHeaderView(text: turnipsDisplay.title(), icon: "dollarsign.circle.fill"),
                footer: predictionFooterView) {
            if viewModel.averagesPrices != nil && viewModel.minMaxPrices != nil {
                predictionSelectorView

                switch turnipsDisplay {
                case .minMax:
                    predictionHeaderView
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)),
                                             count: 3),
                              content:minMaxGridValues)
                case .average:
                    predictionHeaderView
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)),
                                             count: 3),
                              content:averageGridValues)
                case .profits:
                    predictionHeaderView
                    if viewModel.averagesProfits != nil {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)),
                                                 count: 3),
                                  content:averageProfitGridValues)
                    } else {
                        Text("Please add the amount of turnips you bought and for how much")
                            .foregroundColor(.acHeaderBackground)
                            .onTapGesture {
                                self.presentedSheet = .turnipsForm(subManager: self.subManager)
                            }
                    }
                case .chart:
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
}

extension TurnipsView {
    private enum Meridian { case am, pm }

    private func weekDaysText(row: Int) -> some View {
        HStack {
            Text(LocalizedStringKey(labels[row]))
                .font(.body)
                .foregroundColor(.acText)
            Spacer()
        }
    }
    
    struct GridContent<Content: View>: View {
        let rows: Int
        let columns: Int
        let content: (Int, Int) -> Content
        
        init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
            self.rows = rows
            self.columns = columns
            self.content = content
        }
        
        var body: some View {
            ForEach(0..<rows) { row in
                ForEach(0..<columns) { column in
                    Group {
                        content(row, column)
                    }.frame(height: 50)
                }
            }
        }
    }
    
    @ViewBuilder
    private func averageGridValues() -> some View {
        GridContent(rows: labels.count, columns: 3) { row, column in
            switch column {
            case 0: weekDaysText(row: row)
            case 1: averagePriceText(dayNumber: row, meridian: .am)
            case 2: averagePriceText(dayNumber: row, meridian: .pm)
            default: EmptyView()
            }
        }
    }

    @ViewBuilder
    private func minMaxGridValues() -> some View {
        GridContent(rows: labels.count, columns: 3) { row, column in
            switch column {
            case 0: weekDaysText(row: row)
            case 1: minMaxPriceText(dayNumber: row, meridian: .am)
            case 2: minMaxPriceText(dayNumber: row, meridian: .pm)
            default: EmptyView()
            }
        }
    }

    @ViewBuilder
    private func averageProfitGridValues() -> some View {
        GridContent(rows: labels.count, columns: 3) { row, column in
            switch column {
            case 0: weekDaysText(row: row)
            case 1: averageProfitText(dayNumber: row, meridian: .am)
            case 2: averageProfitText(dayNumber: row, meridian: .pm)
            default: EmptyView()
            }
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
