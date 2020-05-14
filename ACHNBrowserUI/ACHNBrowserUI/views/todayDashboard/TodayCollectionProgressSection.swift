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
        Section(header: SectionHeaderView(text: "Collection Progress", icon: "chart.pie.fill")) {
            generateBody()
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
    }

    private func generateBody() -> some View {
        VStack(spacing: 4) {
            if items.categories[.housewares]?.isEmpty == false {
                NavigationLink(destination: CollectionProgressDetailView()) {
                    VStack(spacing: 4) {
                        ForEach(Category.collectionCategories().prefix(4).map{ $0 }, id: \.self) { category in
                            CollectionProgressRow(category: category, barHeight: 12)
                                .padding(.trailing, 8)
                        }
                    }
                }
                shareButton.padding(.top, 12)
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
        .animation(.interactiveSpring())
    }
        
    private var shareButton: some View {
        Button(action: { self.generateAndShareImage() } ) {
            HStack {
                Image(systemName: "square.and.arrow.up").padding(.bottom, 4)
                Text("Share")
            }
            .font(Font.system(size: 16, weight: .bold, design: .rounded))
        }
        .accentColor(.acText)
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .foregroundColor(Color("ACBackground"))
        )
        .buttonStyle(PlainButtonStyle())
    }

    private func generateAndShareImage() {
        let image = List {
            body
        }
        .frame(width: 350, height: 270)
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .environmentObject(UserCollection.shared)
        .environmentObject(Items.shared)
        .asImage()
        self.sheet = .share(content: [ItemDetailSource(name: "My collection progress", image: image)])
    }
}

struct TodayCollectionProgressSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayCollectionProgressSection(viewModel: DashboardViewModel(),
                                               sheet: .constant(nil))
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
        .environmentObject(UserCollection.shared)
        .environmentObject(Items.shared)
        
    }
}
