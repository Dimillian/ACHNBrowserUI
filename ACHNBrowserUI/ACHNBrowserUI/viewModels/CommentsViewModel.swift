//
//  CommentsViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 15/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Backend

class CommentsViewModel: ObservableObject {
    let model: CloudModel
    
    @Published var comments: [Comment] = []
    @Published var isLoading = true
    @Published var isPosting = false
    @Published var inDeletion: String?
    
    private let commentService: CommentService
    private var commentsCancellable: AnyCancellable?
    
    init(model: CloudModel, commentService: CommentService = .shared) {
        self.model = model
        self.commentService = commentService
        
        if let record = model.record {
            self.commentsCancellable = commentService.$comments.sink { comments in
                DispatchQueue.main.async {
                    if let comments = comments[record.recordID]  {
                        self.comments = comments
                        self.isLoading = false
                        self.isPosting = false
                        self.inDeletion = nil
                    }
                }
            }
        }
        
        self.fetchComments()
    }
    
    func fetchComments() {
        if comments.isEmpty {
            isLoading = true
        }
        if let record = model.record {
            commentService.fetchComments(record: record)
        }
    }
    
    func addComment(comment: Comment) {
        isPosting = true
        if let record = model.record {
            commentService.addComment(comment: comment,
                                      owner: record)
        }
    }
    
    func deleteComment(comment: Comment) {
        if let record = model.record {
            isLoading = true
            inDeletion = comment.id
            commentService.deleteComment(comment: comment,
                                         owner: record)
        }
    }
    
}
