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
    
    @EnvironmentObject private var subManager: SubcriptionManager
    @ObservedObject private var viewModel = TurnipsViewModel()
    @State private var presentedSheet: Sheet.SheetType?
    @State private var turnipsDisplay: TurnipsDisplay = .minMax
    
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
                    self.presentedSheet = .subscription(subManager: self.subManager)
                }) {
                    Text("To help us support the application and get turnip predictions notification, you can try out AC Helper+")
                        .foregroundColor(.acSecondaryText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                }
                Button(action: {
                    self.presentedSheet = .subscription(subManager: self.subManager)
                }) {
                    Text("See more...")
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
                    """
                    You'll receive prices predictions in \(viewModel.pendingNotifications - 1) upcoming
                    daily notifications.
                    """)
                    .font(.footnote)
                    .foregroundColor(.catalogUnselected)
                    .lineLimit(nil)) {
            if viewModel.averagesPrices != nil && viewModel.minMaxPrices != nil {
                Picker(selection: $turnipsDisplay, label: Text("")) {
                    ForEach(TurnipsDisplay.allCases, id: \.self) { section in
                        Text(section.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                if turnipsDisplay != .chart {
                    if turnipsDisplay == .profits && viewModel.averagesProfits != nil {
                        Text("Profits estimates are computed using the average of the current period")
                            .foregroundColor(.acSecondaryText)
                    }
                    HStack {
                        Text("Day").fontWeight(.bold)
                        Spacer()
                        Text("AM").fontWeight(.bold)
                        Spacer()
                        Text("PM").fontWeight(.bold)
                    }
                }
                
                if turnipsDisplay == .average {
                    ForEach(0..<viewModel.averagesPrices!.count) { i in
                        TurnipsAveragePriceRow(label: self.labels[i],
                                               prices: self.viewModel.averagesPrices![i])
                    }
                } else if turnipsDisplay == .minMax {
                    ForEach(0..<viewModel.minMaxPrices!.count) { i in
                        TurnipsAveragePriceRow(label: self.labels[i],
                                               minMaxPrices: self.viewModel.minMaxPrices![i])
                    }
                } else if turnipsDisplay == .profits {
                    if viewModel.averagesProfits != nil {
                        ForEach(labels, id: \.self) { day in
                            TurnipsAveragePriceRow(label: day,
                                                    prices: self.viewModel.averagesProfits![self.labels.firstIndex(of: day)!])
                        }
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
    
    private var exchangeSection: some View {
        Group {
            if viewModel.islands?.isEmpty == false {
                Section(header: SectionHeaderView(text: "Exchange")) {
                    viewModel.islands.map {
                        ForEach($0) { island in
                            NavigationLink(destination: IslandDetailView(island: island)) {
                                TurnipIslandRow(island: island)
                            }
                        }
                    }
                }
            } else {
                EmptyView()
            }
        }
    }
}
