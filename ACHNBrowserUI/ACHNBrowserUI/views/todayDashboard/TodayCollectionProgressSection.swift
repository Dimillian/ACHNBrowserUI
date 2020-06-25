//
//  TodayCollectionProgressSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend
import UI

struct TodayCollectionProgressSection: View {
    @EnvironmentObject private var items: Items    
    @ObservedObject var viewModel: DashboardViewModel
    @Binding var sheet: Sheet.SheetType?
    
    private let barHeight: CGFloat = 12
    
    var body: some View {
        VStack(spacing: 4) {
            if items.categories.keys.count == Category.allCases.count {
                NavigationLink(destination: CollectionProgressDetailView()) {
                    VStack(spacing: 4) {
                        ForEach(Category.collectionCategories().prefix(5).map{ $0 }, id: \.self) { category in
                            CollectionProgressRow(category: category, barHeight: 12)
                                .padding(.trailing, 8)
                        }
                    }
                }
            } else {
                RowLoadingView()
                    .frame(height: 150)
            }
        }
        .padding(.vertical, 12)
        .animation(.interactiveSpring())
    }
}

struct TodayCollectionProgressSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayCollectionProgressSection(viewModel: DashboardViewModel(),
                                               sheet: .constant(nil))
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
        .environmentObject(UserCollection.shared)
        .environmentObject(Items.shared)
        
    }
}
