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
    let icon: String
    
    @Binding var currentItem: Item
    @Binding var selectedVariant: Variant?
    
    var body: some View {
        Section(header: SectionHeaderView(text: title, icon: icon)) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(items) { item in
                        VStack(alignment: .center, spacing: 4) {
                            ItemImage(path: item.finalImage,
                                      size: 75)
                            Text(item.localizedName.capitalized)
                                .font(.caption)
                                .foregroundColor(.acText)
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
                                  icon: "eyedropper.full",
                                  currentItem: .constant(static_item),
                                  selectedVariant: .constant(nil))
    }
}
