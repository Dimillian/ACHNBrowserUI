//
//  DodoCodeDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 15/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct DodoCodeDetailView: View {
    @ObservedObject private var viewModel: DodoCodeDetailViewModel
    @State private var commentFieldValue = ""
    @State private var presentedSheet: Sheet.SheetType?
    
    init(code: DodoCode) {
        self.viewModel = DodoCodeDetailViewModel(code: code)
    }
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: viewModel.code.islandName,
                                              icon: "sun.haze.fill")) {
                DodoCodeRow(code: viewModel.code, showButtons: true)
            }
            Section(header: SectionHeaderView(text: "Comments", icon: "bubble.left.fill")) {
                addCommentView
                if viewModel.comments.isEmpty && viewModel.isLoading {
                    RowLoadingView(isLoading: .constant(true))
                } else if !viewModel.comments.isEmpty {
                    ForEach(viewModel.comments, content: makeCommentRow)
                } else {
                    Text("Be the first to leave a comment!").foregroundColor(.acSecondaryText)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Comments")
        .navigationBarItems(trailing: refreshButton)
        .sheet(item: $presentedSheet, content: { Sheet(sheetType: $0) })
        .onAppear {
            self.viewModel.fetchComments()
        }
    }
    
    private func makeCommentRow(comment: Comment) -> some View {
        VStack(alignment: .leading) {
            Text("\(comment.name) from \(comment.islandName)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.acText)
                .lineLimit(1)
            Text(comment.text)
                .font(.body)
                .foregroundColor(.acText)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text(self.formatter.string(from: comment.creationDate))
                    .font(.footnote)
                    .foregroundColor(.acSecondaryText)
                Spacer()
                if comment.isMine {
                    Button(action: {
                        self.viewModel.deleteComment(comment: comment)
                    }) {
                        Group {
                            if viewModel.inDeletion == comment.id {
                                ActivityIndicator(isAnimating: .constant(true),
                                                  style: .medium)
                            } else {
                                ButtonImageCounterOverlay(symbol: "trash",
                                                          foregroundColor: .red,
                                                          counter: 0)
                            }
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.trailing, 4)
                }
            }
        }
    }
    
    private var addCommentView: some View {
        Group {
            if !DodoCodeService.shared.canEdit {
                Text("You need to have an iCloud account in your device settings in order to add comments")
                    .foregroundColor(.acSecondaryText)
            } else if AppUserDefaults.shared.islandName.isEmpty || AppUserDefaults.shared.inGameName.isEmpty {
                Button(action: {
                    self.presentedSheet = .settings(subManager: SubscriptionManager.shared,
                                                    collection: UserCollection.shared)
                }) {
                    Text("In order to add a comment you must add an island name and a username. Tap here to add them in settings")
                        .foregroundColor(.acSecondaryText)
                }
            } else {
                if viewModel.isPosting {
                    RowLoadingView(isLoading: .constant(true))
                } else {
                    HStack {
                        TextField("Add your comment", text: $commentFieldValue)
                            .foregroundColor(.acText)
                            .font(.headline)
                            .accentColor(.acHeaderBackground)
                        Button(action: {
                            if !self.commentFieldValue.isEmpty {
                                let comment = Comment(text: self.commentFieldValue,
                                                      name: AppUserDefaults.shared.inGameName,
                                                      islandName: AppUserDefaults.shared.islandName)
                                self.viewModel.addComment(comment: comment)
                                self.commentFieldValue = ""
                            }
                        }) {
                            Text("Send")
                                .foregroundColor(.blue)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
    
    private var refreshButton: some View {
        Button(action: {
            self.viewModel.fetchComments()
        }) {
            if viewModel.isLoading || viewModel.isPosting {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                Image(systemName: "arrow.counterclockwise.circle").imageScale(.large)
            }
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
    }
}

struct DodoCodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DodoCodeDetailView(code: static_dodoCode)
    }
}
