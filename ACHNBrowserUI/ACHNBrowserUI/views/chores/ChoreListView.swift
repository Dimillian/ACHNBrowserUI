//
//  ChoreListView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 29.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ChoreListView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: ChoreListViewModel
    @State private var sheet: Sheet.SheetType?

    // MARK: - Life cycle

    init(viewModel: ChoreListViewModel = ChoreListViewModel()) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            Button(action: {
                self.sheet = .choreForm(chore: nil)
            }, label: {
                Text("Add Chore")
                    .foregroundColor(.acHeaderBackground)
            })

            self.makeDescriptionView()

            ForEach(self.viewModel.chores, id: \.id) { chore in
                ChoreListRowView(chore: chore).onTapGesture {
                    self.viewModel.toggleChore(chore)
                }
            }.onDelete { indexes in
                self.viewModel.deleteChore(at: indexes.first!)
            }
        }
        .navigationBarTitle(Text("Chores"), displayMode: .automatic)
        .navigationBarItems(trailing: self.makeNavigationBarItems() )
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
    }

    // MARK: - Private

    private func makeDescriptionView() -> some View {
        guard viewModel.shouldShowDescriptionView else {
            return EmptyView().eraseToAnyView()
        }

        return MessageView(string: "Have a friend to visit? A gift to a villager? Track your chores and to-dos here.")
            .eraseToAnyView()
    }

    private func makeNavigationBarItems() -> some View {
        guard viewModel.shouldShowResetButton else {
            return EmptyView().eraseToAnyView()
        }

        return Button("Reset") {
            self.viewModel.resetChores()
        }.eraseToAnyView()
    }
}

// MARK: - Preview

#if DEBUG
struct ChoreListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChoreListView()
        }
        .environmentObject(UserCollection.shared)
    }
}
#endif
