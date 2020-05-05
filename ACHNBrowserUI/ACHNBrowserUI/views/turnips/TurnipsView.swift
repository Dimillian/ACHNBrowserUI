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
        case average, minMax, profits
        
        func title() -> String {
            switch self {
            case .average: return "Average daily buy prices"
            case .minMax: return "Daily min-max prices"
            case .profits: return "Average profits"
            }
        }
    }
    
    private enum Sheet: String, Identifiable {
        case form, subscription
        
        var id: String {
            self.rawValue
        }
    }
    
    @EnvironmentObject private var subManager: SubcriptionManager
    @ObservedObject private var viewModel = TurnipsViewModel()
    @State private var presentedSheet: Sheet?
    @State private var turnipsDisplay: TurnipsDisplay = .average
    
    private let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            if UIDevice.current.userInterfaceIdiom == .pad {
                TurnipsFormView(turnipsViewModel: viewModel)
            }
            List {
                if subManager.subscriptionStatus == .notSubscribed {
                    subscriptionSection
                }
                if UIDevice.current.userInterfaceIdiom != .pad ||
                    (UIDevice.current.orientation == .portrait ||
                        UIDevice.current.orientation == .portraitUpsideDown){
                    Section(header: SectionHeaderView(text: "Your prices")) {
                        Button(action: {
                            self.presentedSheet = .form
                        }) {
                            Text(TurnipFields.exist() ? "Edit your in game prices" : "Add your in game prices")
                                .foregroundColor(.bell)
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
            .sheet(item: $presentedSheet, content: makeSheet)
        }
        .onAppear(perform: NotificationManager.shared.registerForNotifications)
    }
}

// MARK: - Views
extension TurnipsView {
    
    private func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .form:
            return AnyView(NavigationView {
                TurnipsFormView(turnipsViewModel: viewModel).environmentObject(subManager)
                
                }.navigationViewStyle(StackNavigationViewStyle()))
        case .subscription:
            return AnyView(SubscribeView().environmentObject(subManager))
        }
    }
    
    private var subscriptionSection: some View {
        Section(header: SectionHeaderView(text: "AC Helper+")) {
            VStack(spacing: 8) {
                Button(action: {
                    self.presentedSheet = .subscription
                }) {
                    Text("To help us support the application and get turnip predictions notification, you can try out AC Helper+")
                        .foregroundColor(.secondaryText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                }
                Button(action: {
                    self.presentedSheet = .subscription
                }) {
                    Text("See more...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.buttonStyle(PlainRoundedButton())
                    .accentColor(.bell)
                    .padding(.bottom, 8)
            }
        }
    }
    
    private var predictionsSection: some View {
        Section(header: SectionHeaderView(text: turnipsDisplay.title()),
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
                
                HStack {
                    Text("Day").fontWeight(.bold)
                    Spacer()
                    Text("AM").fontWeight(.bold)
                    Spacer()
                    Text("PM").fontWeight(.bold)
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
                            .foregroundColor(.bell)
                            .onTapGesture {
                                self.presentedSheet = .form
                        }
                    }
                }
            } else {
                Text("Add your in game turnip prices to see predictions")
                    .foregroundColor(.bell)
                    .onTapGesture {
                        self.presentedSheet = .form
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
