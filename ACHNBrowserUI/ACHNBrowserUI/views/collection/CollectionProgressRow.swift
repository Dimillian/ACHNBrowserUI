//
//  CollectionProgressRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 13/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct CollectionProgressRow: View {
    @EnvironmentObject private var items: Items
    @EnvironmentObject private var collection: UserCollection
    
    @State private var inCollection = 0
    @State private var total = 0
    
    let category: Backend.Category
    let barHeight: CGFloat
    
    var body: some View {
        HStack {
            Image(category.iconName())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: barHeight + 12)
            
            Group {
                ProgressView(progress: CGFloat(inCollection) / CGFloat(total),
                             trackColor: .acText,
                             progressColor: .acHeaderBackground,
                             height: barHeight)
            }
            .frame(height: self.barHeight)
            
            Text("\(inCollection) / \(total)")
                .font(Font.system(size: 12,
                                  weight: Font.Weight.semibold,
                                  design: Font.Design.rounded).monospacedDigit())
                .foregroundColor(.acText)
        }.onAppear {
            DispatchQueue.global().async {
                let caught = self.collection.itemsIn(category: self.category)
                var total = 0
                if self.category == .art {
                    total = self.items.categories[self.category]?.filter({ !$0.name.contains("(fake)") }).count ?? 0
                } else {
                    total = self.items.categories[self.category]?.count ?? 0
                }
                DispatchQueue.main.async {
                    self.inCollection = caught
                    self.total = total
                }
            }
        }
    }
}

struct CollectionProgressRow_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CollectionProgressRow(category: .housewares, barHeight: 12)
                .environmentObject(UserCollection.shared)
                .environmentObject(Items.shared)
        }
    }
}
