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
    @EnvironmentObject private var collection: UserCollection
    
    @ObservedObject var viewModel: DashboardViewModel
    @Binding var sheet: Sheet.SheetType?
    
    @State private var isExpanded = false
    private let barHeight: CGFloat = 12
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Collection Progress", icon: "chart.pie.fill")) {
            generateBody()
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
    }

    private func generateBody() -> some View {
        VStack(spacing: 8) {
            if items.categories.isEmpty == false {
                Group {
                    if isExpanded {
                        ForEach(Category.collectionCategories(), id: \.self) { category in
                            self.progressRow(iconName: category.iconName(), for: category)
                        }
                    } else {
                        ForEach(Category.collectionCategories().prefix(4).map{ $0 }, id: \.self) { category in
                            self.progressRow(iconName: category.iconName(), for: category)
                        }
                    }
                    seeMoreButton
                    shareButton.padding(.top, 12)
                }
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
        .animation(.interactiveSpring())
    }
    
    func progressRow(iconName: String, for category: Backend.Category) -> some View {
        let caught = CGFloat(collection.itemsIn(category: category))
        var total: CGFloat = 0
        if category == .art {
            total = CGFloat(items.categories[category]?.filter({ !$0.name.contains("(fake)") }).count ?? 0)
        } else {
            total = CGFloat(items.categories[category]?.count ?? 0)
        }
        
        return HStack {
            Image(iconName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 24)
            
            Group {
                ProgressView(progress: caught / total,
                             trackColor: .acText,
                             progressColor: .acHeaderBackground)
            }
            .frame(height: self.barHeight)
            
            Text("\(Int(caught)) / \(Int(total))")
                .font(Font.system(size: 12,
                                  weight: Font.Weight.semibold,
                                  design: Font.Design.rounded).monospacedDigit())
                .foregroundColor(.acText)
        }
    }
    
    private var seeMoreButton: some View {
        Button(action: {
            self.isExpanded.toggle()
        }) {
            Text(isExpanded ? "See less" : "See more")
                .foregroundColor(.acHeaderBackground)
        }
        .buttonStyle(PlainButtonStyle())
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
        .asImage()
        self.sheet = .share(content: [ItemDetailSource(name: "My collection progress", image: image)])
    }
}

//struct TodayCollectionProgressSection_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            List {
//                TodayCollectionProgressSection()
//            }
//            .listStyle(GroupedListStyle())
//            .environment(\.horizontalSizeClass, .regular)
//        }
//        .previewLayout(.fixed(width: 375, height: 500))
//    }
//}
