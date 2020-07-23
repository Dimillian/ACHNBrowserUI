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
    let category: Backend.Category
    let barHeight: CGFloat
    
    @ObservedObject private var viewModel: CollectionProgressRowViewModel
    
    init(category: Backend.Category, barHeight: CGFloat) {
        self.category = category
        self.viewModel = CollectionProgressRowViewModel(category: category)
        self.barHeight = barHeight
    }
    
    var body: some View {
        HStack {
            Image(category.iconName())
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: barHeight + 12)
            Group {
                ProgressBar(progress: CGFloat(viewModel.inCollection) / CGFloat(viewModel.total),
                             trackColor: .acText,
                             progressColor: .acHeaderBackground,
                             height: barHeight)
            }
            .frame(height: barHeight)
            
            Text("\(viewModel.inCollection) / \(viewModel.total)")
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
        }
    }
}
