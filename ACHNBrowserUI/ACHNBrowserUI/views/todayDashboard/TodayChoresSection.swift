//
//  TodayChoresSection.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 29.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct TodayChoresSection: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: TodayChoresSectionViewModel

    // MARK: - Life cycle

    public init(viewModel: TodayChoresSectionViewModel = TodayChoresSectionViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationLink(destination: LazyView(ChoreListView())) {
            VStack(alignment: .leading) {
                self.makeHeaderView()
                
                HStack(spacing: 15) {
                    self.makeProgressView()
                    self.makeRatioLabel()
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
            }
        }
    }

    // MARK: - Private

    func makeHeaderView() -> some View {
        Text("Manage and keep track of your chores and to-dos.")
            .style(appStyle: .rowDescription)
            .lineLimit(2)
            .frame(maxHeight: .infinity)
            .padding(.top, 8)
    }

    private func makeProgressView() -> some View {
        ProgressBar(progress: CGFloat(viewModel.completeChoresCount) / CGFloat(viewModel.totalChoresCount),
                    trackColor: .acText,
                    progressColor: .acHeaderBackground,
                    height: 12)
    }

    private func makeRatioLabel() -> some View {
        return Text("\(viewModel.completeChoresCount) / \(viewModel.totalChoresCount)")
            .font(Font.system(size: 12,
                              weight: Font.Weight.semibold,
                              design: Font.Design.rounded).monospacedDigit())
            .foregroundColor(.acText)
    }
}

// MARK: - Preview

#if DEBUG
struct TodayCustomTasksSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayChoresSection()
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(UserCollection.shared)
    }
}
#endif
