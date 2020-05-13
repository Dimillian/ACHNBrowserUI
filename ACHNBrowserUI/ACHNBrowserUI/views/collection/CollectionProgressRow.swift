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
    
    let category: Backend.Category
    let barHeight: CGFloat
    
    var body: some View {
        let caught = CGFloat(collection.itemsIn(category: category))
        var total: CGFloat = 0
        if category == .art {
            total = CGFloat(items.categories[category]?.filter({ !$0.name.contains("(fake)") }).count ?? 0)
        } else {
            total = CGFloat(items.categories[category]?.count ?? 0)
        }
        
        return HStack {
            Image(category.iconName())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: barHeight + 12)
            
            Group {
                ProgressView(progress: caught / total,
                             trackColor: .acText,
                             progressColor: .acHeaderBackground,
                             height: barHeight)
            }
            .frame(height: self.barHeight)
            
            Text("\(Int(caught)) / \(Int(total))")
                .font(Font.system(size: 12,
                                  weight: Font.Weight.semibold,
                                  design: Font.Design.rounded).monospacedDigit())
                .foregroundColor(.acText)
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
