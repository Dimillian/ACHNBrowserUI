//
//  CommentsSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CommentsSection: View {
    @StateObject private var viewModel: CommentsViewModel
    @State private var commentFieldValue = ""
    @State private var presentedSheet: Sheet.SheetType?
        
    init(model: CloudModel) {
        _viewModel = StateObject(wrappedValue: CommentsViewModel(model: model))
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Comments", icon: "bubble.left.fill")) {
            addCommentView
            if viewModel.comments.isEmpty && viewModel.isLoading {
                RowLoadingView()
            } else if !viewModel.comments.isEmpty {
                ForEach(viewModel.comments, content: makeCommentRow)
            } else {
                Text("Be the first to leave a comment!")
                    .foregroundColor(.acSecondaryText)
                    .listRowBackground(Color.acSecondaryBackground)
            }
        }.listRowBackground(Color.acSecondaryBackground)
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
                Text(comment.creationDate, style: .relative)
                    .font(.footnote)
                    .foregroundColor(.acSecondaryText)
                Spacer()
                if comment.isMine {
                    Button(action: {
                        self.viewModel.deleteComment(comment: comment)
                    }) {
                        Group {
                            if viewModel.inDeletion == comment.id {
                                ProgressView()
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
        }.listRowBackground(Color.acSecondaryBackground)
    }
    
    private var addCommentView: some View {
        Group {
            if !CommentService.shared.canPostComment {
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
                    RowLoadingView()
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
        }.sheet(item: $presentedSheet, content: { Sheet(sheetType: $0) })
    }
}
