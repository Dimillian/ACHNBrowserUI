//
//  DesignFormView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct DesignFormView: View {

    // MARK: - Properties

    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: DesignFormViewModel
    @State private var nameErrorBorderColor: Color = .clear
    @State private var codeErrorBorderColor: Color = .clear

    // MARK: - Life cycle

    init(viewModel: DesignFormViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name")
                    Spacer()
                    TextField("Creator/Item name",
                              text: $viewModel.design.title,
                              onEditingChanged: { _ in self.nameErrorBorderColor = .clear })
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.acText)
                }
                .border(nameErrorBorderColor)

                HStack {
                    Text("Code")
                    Spacer()
                    TextField("MX-XXXX-XXXX-XXXX",
                              text: $viewModel.design.code,
                              onEditingChanged: { _ in self.codeErrorBorderColor = .clear })
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.acText)
                }
                .border(codeErrorBorderColor)

                HStack {
                    Text("Description")
                    Spacer()
                    TextField("Short description about creator/item",
                              text: $viewModel.design.description)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(.acText)
                }
            }
            .navigationBarTitle("Add design")
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
            if self.viewModel.design.title.isEmpty {
                self.nameErrorBorderColor = .red
            }

            if !self.viewModel.design.hasValidCode {
                self.codeErrorBorderColor = .red
            }

            guard
                !self.viewModel.design.title.isEmpty,
                self.viewModel.design.hasValidCode else {
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
struct DesignFormView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DesignFormView(viewModel: DesignFormViewModel(design: nil))

            DesignFormView(viewModel: DesignFormViewModel(design: Design(title: "Jedi",
                                                                         code: "MOPJ15LTDSXC4T",
                                                                         description: "Jedi Tunic")))
                .preferredColorScheme(.dark)
        }
    }
}
#endif
