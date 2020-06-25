//
//  ChoreListView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 29.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Backend
import SwiftUI
import SwiftUIKit

struct ChoreListView: View {

    // MARK: - Properties

    @ObservedObject private var viewModel: ChoreListViewModel
    @State private var sheet: Sheet.SheetType?
    @State private var showActionSheet = false
    @State private var isEditing = false

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
            .listRowBackground(Color.acSecondaryBackground)

            self.makeDescriptionView()
                .listRowBackground(Color.acSecondaryBackground)

            ForEach(self.viewModel.chores, id: \.id) { chore in
                ChoreListRowView(chore: chore)
                    .listRowBackground(Color.acSecondaryBackground)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if self.isEditing {
                            self.sheet = .choreForm(chore: chore)
                        } else {
                            self.viewModel.toggleChore(chore)
                        }
                    }
            }.onDelete { indexes in
                self.viewModel.deleteChore(at: indexes.first!)
            }
        }
        .navigationBarTitle(Text("Chores"), displayMode: .automatic)
        .navigationBarItems(trailing: self.makeNavigationBarItems() )
        .sheet(item: $sheet) { Sheet(sheetType: $0) }
        .environment(\.editMode, .constant(self.isEditing ? .active : .inactive))
        .actionSheet(isPresented: $showActionSheet) { self.makeActionSheet() }
    }

    // MARK: - Private

    private func makeDescriptionView() -> some View {
        guard viewModel.shouldShowDescriptionView else {
            return EmptyView().eraseToAnyView()
        }

        return MessageView("Have a friend to visit? A gift to a villager? Track your chores and to-dos here.")
            .eraseToAnyView()
    }

    private func makeNavigationBarItems() -> some View {
        HStack() {
            Button(action: {
                self.isEditing.toggle()
            }, label: {
                Image(systemName: isEditing ? "pencil.circle.fill" : "pencil.circle")
            })
            .buttonStyle(BorderedBarButtonStyle())
            .accentColor(Color.acText.opacity(0.2))

            Button(action: {
                self.showActionSheet.toggle()
            }, label: {
                Image(systemName: "slider.horizontal.3")
            })
            .buttonStyle(BorderedBarButtonStyle())
            .accentColor(Color.acText.opacity(0.2))
        }
    }

    private func makeActionSheet() -> ActionSheet {
        var buttons: [ActionSheet.Button] = []

        if viewModel.shouldShowResetChores {
            let resetTitle = Text("Reset Finished Chores")
            let resetFinishedButton: ActionSheet.Button = .default(resetTitle) {
                self.viewModel.resetChores()
            }
            buttons.append(resetFinishedButton)
        }

        let visibilityTitle = Text(viewModel.actionSheetVisibilityDescription)
        let visibilityButton: ActionSheet.Button = .default(visibilityTitle) {
            self.viewModel.toggleVisibility()
        }
        buttons.append(visibilityButton)

        let cancelButton: ActionSheet.Button = .cancel()
        buttons.append(cancelButton)

        return ActionSheet(title: Text("Select an Action"), buttons: buttons)
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
