//
//  VariantsForLikeView.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 02/01/2021.
//  Copyright © 2021 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct VariantsForLikeView: View {
    @Binding var item: Item?

    var body: some View {
        ZStack {
            Color.black
                .opacity(item != nil ? 1/6 : 0)
                .onTapGesture { item = nil }
            item.map { item in
                VStack {
                    Spacer()
                    VStack {
                        SectionHeaderView(text: "Variants", icon: "paintbrush.fill").padding()
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(item.variations ?? []) { variant in
                                    ZStack(alignment: .topLeading) {
                                        ItemImage(path: variant.content.image, size: 75)
                                        LikeButtonView(item: item, variant: variant)
                                    }
                                }
                            }.padding()
                        }
                        .listRowInsets(EdgeInsets())
                    }
                    .background(Color.acSecondaryBackground.shadow(radius: 2, x: 0, y: -2))
                    .clipShape(RoundedRectangleOnTop(cornerRadius: 32))
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut)
    }
}

#if DEBUG
struct VariantsForLikeView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        @State private var item: Item?

        var body: some View {
            ZStack {
                Button { item = static_item } label: {
                    Text("Show Variants")
                }
                VariantsForLikeView(item: $item)
            }
        }
    }
}

#endif
