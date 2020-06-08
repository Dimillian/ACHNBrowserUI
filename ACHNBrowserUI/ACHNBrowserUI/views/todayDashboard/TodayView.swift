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
    @EnvironmentObject private var uiState: UIState
    @ObservedObject private var viewModel = DashboardViewModel()
    @State private var selectedSheet: Sheet.SheetType?
            
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                if uiState.routeEnabled {
                    uiState.route.map { route in
                        NavigationLink(destination: route.makeDetailView(),
                                       isActive: $uiState.routeEnabled) {
                                        EmptyView()
                        }.hidden()
                    }
                }

                ForEach(viewModel.sectionOrder) { section in
                    TodaySectionView(section: section,
                                     viewModel: self.viewModel,
                                     selectedSheet: self.$selectedSheet)
                }
                
                if UIDevice.current.userInterfaceIdiom != .pad {
                    editSection
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("\(dateString.capitalized)"))
            .navigationBarItems(leading: aboutButton, trailing: settingsButton)
            
            ActiveCrittersView()
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
        return f.string(from: Date())
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
