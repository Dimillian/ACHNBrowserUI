//
//  ChoreFormView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 29.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct ChoreFormView: View {

    // MARK: - Properties

    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: ChoreFormViewModel
    @State private var titleErrorBorderColor: Color = .clear

    // MARK: - Life cycle

    init(viewModel: ChoreFormViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Title")
                    Spacer()
                    TextField("Chore title",
                              text: $viewModel.chore.title,
                              onEditingChanged: { _ in self.titleErrorBorderColor = .clear })
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.acText)
                }
                .border(titleErrorBorderColor)
                .listRowBackground(Color.acSecondaryBackground)

                HStack {
                    Text("Description")
                    Spacer()
                    TextField("Short description about the chore",
                              text: $viewModel.chore.description)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.acText)
                }
                .listRowBackground(Color.acSecondaryBackground)
            }
            .navigationBarTitle("Add Chore")
            .navigationBarItems(leading: dismissButton, trailing: saveButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // MARK: - Private

    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.red)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.red.opacity(0.2))
    }

    private var saveButton: some View {
        Button(action: {
            guard !self.viewModel.chore.title.isEmpty else {
                self.titleErrorBorderColor = .red
                return
            }

            self.viewModel.save()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "checkmark.seal.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acTabBarBackground)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acTabBarBackground.opacity(0.2))
    }
}

// MARK: - Preview

#if DEBUG
struct ChoreFormView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChoreFormView(viewModel: ChoreFormViewModel(chore: nil))

            ChoreFormView(viewModel: ChoreFormViewModel(chore: Chore(title: "Collect Apple",
                                                                     description: "To sell in another island",
                                                                     isFinished: false)))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
