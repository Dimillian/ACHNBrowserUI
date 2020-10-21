//
//  TodayCurrentlyAvailableSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend

struct TodayCurrentlyAvailableSection: View {
    @Environment(\.currentDate) private var currentDate
    @StateObject private var viewModel = ActiveCrittersViewModel()
    @State private var isNavigationLinkActive = false
    @State private var openingTab: ActiveCrittersViewModel.CritterType = .fish
    
    // MARK: - Body
    var body: some View {
        VStack {
            NavigationLink(destination: ActiveCrittersView(tab: openingTab),
                           isActive: $isNavigationLinkActive) {
                
            }
            
            if viewModel.crittersInfo[.bugs]?.active.isEmpty == false &&
                viewModel.crittersInfo[.fish]?.active.isEmpty == false {
                HStack(alignment: .top) {
                    Button {
                        openingTab = .fish
                        isNavigationLinkActive = true
                    } label: {
                        makeCell(for: .fish,
                                 caught: viewModel.crittersInfo[.fish]?.caught.count ?? 0,
                                 available: viewModel.crittersInfo[.fish]?.active.count ?? 0 ,
                                 numberNew: viewModel.crittersInfo[.fish]?.new.count ?? 0)
                    }.buttonStyle(BorderlessButtonStyle())
                    
                    Divider()
                    Button {
                        openingTab = .bugs
                        isNavigationLinkActive = true
                    } label: {
                        makeCell(for: .bugs,
                                 caught: viewModel.crittersInfo[.bugs]?.caught.count ?? 0,
                                 available: viewModel.crittersInfo[.bugs]?.active.count ?? 0,
                                 numberNew: viewModel.crittersInfo[.bugs]?.new.count ?? 0)
                    }.buttonStyle(BorderlessButtonStyle())
                }
            } else {
                RowLoadingView()
            }
            Divider()
            if viewModel.crittersInfo[.seaCreatures]?.active.isEmpty == true {
                RowLoadingView()
            } else {
                Button {
                    openingTab = .seaCreatures
                    isNavigationLinkActive = true
                } label: {
                    makeCell(for: .seaCreatures,
                             caught: viewModel.crittersInfo[.seaCreatures]?.caught.count ?? 0,
                             available: viewModel.crittersInfo[.seaCreatures]?.active.count ?? 0 ,
                             numberNew: viewModel.crittersInfo[.seaCreatures]?.new.count ?? 0)
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(.vertical)
        .onAppear {
            viewModel.updateCritters(for: currentDate)
        }
    }
    
    private func makeCell(for type: ActiveCrittersViewModel.CritterType,
                          caught: Int, available: Int, numberNew: Int = 0) -> some View {
        VStack(spacing: 0) {
            Image("\(type.imagePrefix())\(dayNumber())")
                .renderingMode(.original)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 48)
            
            Group {
                if type == .bugs {
                    Text("\(caught)/\(available) Bugs")
                } else if type == .fish {
                    Text("\(caught)/\(available) Fish")
                } else {
                    Text("\(caught)/\(available) Sea Creatures")
                }
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.acText)
            
            if numberNew > 0 {
                Text("\(numberNew) NEW")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Capsule().foregroundColor(Color.acText.opacity(0.2)))
                    .padding(.top)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func dayNumber() -> Int {
        return Calendar.current.dateComponents([.day], from: currentDate).day ?? 0
    }
}

struct TodayCurrentlyAvailableSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayCurrentlyAvailableSection()
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
