//
//  ItemsCrosslineSectionView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 26/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemsCrosslineSectionView: View {
    let title: String
    let items: [Item]
    
    @Binding var currentItem: Item
    @Binding var selectedVariant: Variant?
    
    var body: some View {
        Section(header: SectionHeaderView(text: title)) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        VStack(alignment: .center, spacing: 4) {
                            ItemImage(path: item.filename,
                                      size: 75)
                            Text(item.name)
                                .font(.caption)
                                .foregroundColor(.text)
                        }.onTapGesture {
                            FeedbackGenerator.shared.triggerSelection()
                            self.selectedVariant = nil
                            self.currentItem = item
                        }
                    }
                }.padding()
            }
            .listRowInsets(EdgeInsets())
        }
    }
}

struct ItemsCrosslineSectionView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsCrosslineSectionView(title: "Preview",
                                  items: [],
                                  currentItem: .constant(static_item),
                                  selectedVariant: .constant(nil))
    }
}
