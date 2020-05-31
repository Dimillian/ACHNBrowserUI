//
//  GridStack.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 24/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

// See https://www.hackingwithswift.com/quick-start/swiftui/how-to-position-views-in-a-grid
struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let spacing: CGFloat?
    let showDivider: Bool
    let content: (Int, Int) -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<rows, id: \.self) { row in
                VStack {
                    if row == 0 { Spacer() }
                    HStack {
                        ForEach(0..<self.columns, id: \.self) { column in
                            HStack {
                                column > 0 ? Spacer().eraseToAnyView() : EmptyView().eraseToAnyView()
                                self.content(row, column)
                                Spacer()
                            }
                        }
                    }
                    if row == self.rows - 1 {
                        Spacer()
                    } else {
                        self.divider
                    }
                }
            }
        }
    }

    init(
        rows: Int,
        columns: Int,
        spacing: CGFloat? = nil,
        showDivider: Bool = true,
        @ViewBuilder content: @escaping (Int, Int) -> Content
    ) {
        self.rows = rows
        self.columns = columns
        self.content = content
        self.spacing = spacing
        self.showDivider = showDivider
    }

    var divider: some View {
        self.showDivider ? Divider().eraseToAnyView() : Color.clear.frame(height: 1).eraseToAnyView()
    }
}
