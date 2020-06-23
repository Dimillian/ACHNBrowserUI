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
    // MARK: - Body
    var body: some View {
        NavigationLink(destination: ActiveCrittersView()) {
            TodayCurrentlyAvailableSectionContent()
        }
        .padding(.vertical)
    }
}

struct TodayCurrentlyAvailableSectionContent: View {
    @StateObject private var viewModel = ActiveCrittersViewModel()
        
    var body: some View {
        Group {
            if viewModel.crittersInfo[.bugs]?.active.isEmpty == false &&
                viewModel.crittersInfo[.fish]?.active.isEmpty == false {
                HStack(alignment: .top) {
                    makeCell(for: .fish,
                             caught: viewModel.crittersInfo[.fish]?.caught.count ?? 0,
                             available: viewModel.crittersInfo[.fish]?.active.count ?? 0 ,
                             numberNew: viewModel.crittersInfo[.fish]?.new.count ?? 0)
                    Divider()
                    makeCell(for: .bugs,
                             caught: viewModel.crittersInfo[.bugs]?.caught.count ?? 0,
                             available: viewModel.crittersInfo[.bugs]?.active.count ?? 0,
                             numberNew: viewModel.crittersInfo[.bugs]?.new.count ?? 0)
                }
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
    }
    
    
    private func makeCell(for type: ActiveCrittersViewModel.CritterType,
                          caught: Int, available: Int, numberNew: Int = 0) -> some View {
        VStack(spacing: 0) {
            Image("\(type.imagePrefix())\(dayNumber())")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 48)
            
            Group {
                type == .bugs ? Text("\(caught)/\(available) Bugs") : Text("\(caught)/\(available) Fish")
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
        return Calendar.current.dateComponents([.day], from: Date()).day ?? 0
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
