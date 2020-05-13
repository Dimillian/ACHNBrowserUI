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
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject var viewModel: DashboardViewModel
    @Binding var sheet: Sheet.SheetType?
    
    var barHeight: CGFloat = 12
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Collection Progress", icon: "chart.pie.fill")) {
            generateBody()
                .frame(maxWidth: .infinity)
                .padding(.vertical)
        }
    }

    private func generateBody() -> some View {
        VStack(spacing: 8) {
            if (!viewModel.fishes.isEmpty && !viewModel.bugs.isEmpty && !viewModel.fossils.isEmpty && !viewModel.art.isEmpty) {
                progressRow(iconName: "Fish28", for: viewModel.fishes)
                progressRow(iconName: "Ins13", for: viewModel.bugs)
                progressRow(iconName: "icon-fossil", for: viewModel.fossils)
                progressRow(iconName: "icon-leaf", for: viewModel.art)
                shareButton.padding(.top, 12)
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
        .animation(.interactiveSpring())
    }
    
    func progressRow(iconName: String, for items: [Item]) -> some View {
        let caught = CGFloat(collection.caughtIn(list: items))
        let total = CGFloat(items.count)
        
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

    var shareButton: some View {
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
