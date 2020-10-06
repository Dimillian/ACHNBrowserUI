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
    
    // MARK: - Vars
    @Environment(\.currentDate) private var currentDate
    @StateObject private var viewModel = DashboardViewModel()
    @State private var selectedSheet: Sheet.SheetType?
            
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sectionOrder) { section in
                    TodaySectionView(section: section,
                                     viewModel: self.viewModel,
                                     selectedSheet: self.$selectedSheet)
                        .listRowBackground(Color.acSecondaryBackground)
                }
                
                if UIDevice.current.userInterfaceIdiom != .pad {
                    editSection
                        .listRowBackground(Color.acSecondaryBackground)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("\(dateString.capitalized)"))
            .navigationBarItems(leading: aboutButton, trailing: settingsButton)
            .sheet(item: $selectedSheet, content: { Sheet(sheetType: $0) })
            .onAppear(perform: NewsArticleService.shared.fetchNews)
            .onAppear(perform: DodoCodeService.shared.refresh)
            .onAppear(perform: DreamCodeService.shared.refresh)
            
            ActiveCrittersView(tab: .fish)
        }
    }

    var editSection: some View {
        Section {
            NavigationLink(destination: TodaySectionEditView(viewModel: viewModel)) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(.body, design: .rounded))
                    Text("Change Section Order")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                }.foregroundColor(.acHeaderBackground)
            }
        }
    }
    
    // MARK: - Navigation Bar Button(s)
    private var settingsButton: some View {
        Button(action: { self.selectedSheet = .settings(subManager: SubscriptionManager.shared,
                                                        collection: UserCollection.shared) } ) {
            Image(systemName: "slider.horizontal.3")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffect()
    }
    
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
    
    // MARK: - Others
    private var dateString: String {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return f.string(from: currentDate)
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodayView()
        }
        .environmentObject(Items.shared)
        .environmentObject(UIState())
    }
}
