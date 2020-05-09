//
//  TodayView.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Combine
import Backend
import UI

struct TodayView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var userDefaults = AppUserDefaults.shared
    @ObservedObject private var viewModel = DashboardViewModel()
    @ObservedObject private var villagersViewModel = VillagersViewModel()
    @ObservedObject private var turnipsPredictionsService = TurnipsPredictionService.shared
    
    @State private var selectedSheet: Sheet?
    @State private var showWhatsNew: Bool = true
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                
                if showWhatsNew { self.whatsNewSection }
                
                TodayCurrentlyAvailableSection(viewModel: viewModel)
                TodayCollectionProgressSection()
                TodayTurnipSection()
                TodayTasksSection()
                TodayEventsSection()
                TodayBirthdaysSection(villagers: villagersViewModel.todayBirthdays)
                
                self.nookazonSection
                self.arrangeSectionsButton
                
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("\(dateString())"))
            .navigationBarItems(trailing: settingsButton)
            .sheet(item: $selectedSheet, content: makeSheet)
        }
    }
    
    var whatsNewSection: some View {
        Section(header: SectionHeaderView(text: "What's New", icon: "star.circle.fill")) {
            HStack {
                Text("See what's new in update 2020.2")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(Color("ACText"))
                    .onTapGesture { self.selectedSheet = Sheet.whatsNew }
                
                Spacer()
                
                Button(action: { self.showWhatsNew = false } ) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .imageScale(.medium)
                }
                .accentColor(Color("ACText"))
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).foregroundColor(Color("ACText").opacity(0.2)))
                
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .animation(.default)
        }
    }
    
    var nookazonSection: some View {
        Section(header: SectionHeaderView(text: "New on Nookazon", icon: "cart.fill")) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<10) { i in
                        HStack {
                            VStack {
                                Circle()
                                    .foregroundColor(Color("ACSecondaryText"))
                                    .frame(width: 66, height: 66)
                                
                                Text("Item \(i)")
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("ACText"))
                                    .padding(.bottom, 4)
                            }
                            .padding(.horizontal)
                            .onTapGesture { self.selectedSheet = Sheet.safari(URL(string: "http://nookazon.com")!) }
                            
                            Divider()
                        }
                    }
                }
            }
            .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
    var arrangeSectionsButton: some View {
        Section {
            Button(action: { self.selectedSheet = Sheet.rearrange }) {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                        .font(.system(.body, design: .rounded))
                    Text("Change Section Order")
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .accentColor(Color("ACHeaderBackground"))
            //                .listRowBackground(Color("ACHeaderBackground"))
        }
    }
    
    // MARK: - Navigation Bar Button(s)
    private var settingsButton: some View {
        Button(action: { self.selectedSheet = Sheet.settings } ) {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .imageScale(.medium)
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).foregroundColor(Color("ACText").opacity(0.2)))
    }
    
    private func dateString() -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f.string(from: Date())
    }
}

// MARK: - Sheet Management
extension TodayView {
    enum Sheet: Identifiable {
        case safari(URL), settings, about, rearrange, whatsNew
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            case .settings:
                return "settings"
            case .about:
                return "about"
            case .rearrange:
                return "rearrange"
            case .whatsNew:
                return "whatsNew"
            }
        }
    }
    
    private func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            return AnyView(
                NavigationView {
                    SettingsView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            )
        case .rearrange:
            return AnyView(
                NavigationView {
                    TodaySectionEditView()
                }
                .navigationViewStyle(StackNavigationViewStyle())
            )
            
        case .whatsNew:
            return AnyView(
                ScrollView { Text("Here's whats new in this version of the app") }
            )
            
        default:
            return AnyView(Text("\(sheet.id)"))
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            TodayView()
        }
    }
}
