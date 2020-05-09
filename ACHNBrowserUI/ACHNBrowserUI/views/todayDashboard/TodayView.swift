//
//  TodayView.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Combine
import Backend
import UI

struct TodayView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subManager: SubscriptionManager
    @ObservedObject private var userDefaults = AppUserDefaults.shared
    @ObservedObject private var viewModel = DashboardViewModel()
    @ObservedObject private var villagersViewModel = VillagersViewModel()
    @ObservedObject private var turnipsPredictionsService = TurnipsPredictionService.shared
    
    @State private var selectedSheet: Sheet.SheetType?
    @State private var showWhatsNew: Bool = false
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                
                if showWhatsNew {
                    TodayWhatsNewSection(showWhatsNew: $showWhatsNew)
                }
                
                TodayEventsSection()
                TodayCurrentlyAvailableSection(viewModel: viewModel)
                TodayCollectionProgressSection(viewModel: viewModel, sheet: $selectedSheet)
                TodayBirthdaysSection(villagers: villagersViewModel.todayBirthdays)
                TodayTurnipSection(predictions: turnipsPredictionsService.predictions)
                    .onTapGesture {
                        self.uiState.selectedTab = .turnips
                }
                //TodayTasksSection()
                TodayNookazonSection(sheet: $selectedSheet, viewModel: viewModel)
                TodaySubscribeSection(sheet: $selectedSheet)
                //self.arrangeSectionsButton
                
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("\(dateString())"))
            .navigationBarItems(leading: aboutButton, trailing: settingsButton)
            .sheet(item: $selectedSheet, content: { Sheet(sheetType: $0) })
            
            ActiveCrittersView(activeFishes: viewModel.fishes.filterActive(),
                               activeBugs: viewModel.bugs.filterActive())
        }
    }
            
    var arrangeSectionsButton: some View {
        Section {
            Button(action: { self.selectedSheet = .rearrange }) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(.body, design: .rounded))
                    Text("Change Section Order")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .accentColor(.acHeaderBackground)
        }
    }
    
    // MARK: - Navigation Bar Button(s)
    private var settingsButton: some View {
        Button(action: { self.selectedSheet = .settings(subManager: self.subManager) } ) {
            Image(systemName: "slider.horizontal.3")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffect()
    }
    
    // MARK: - Navigation Bar Button(s)
    private var aboutButton: some View {
        Button(action: { self.selectedSheet = .about } ) {
            Image(systemName: "info.circle")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffect()
    }
    
    private func dateString() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: Date())
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodayView()
        }
    }
}
