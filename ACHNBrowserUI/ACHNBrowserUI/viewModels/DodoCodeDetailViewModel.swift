//
//  DodoCodeDetailViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 15/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Backend

class DodoCodeDetailViewModel: ObservableObject {
    let code: DodoCode
    
    @Published var comments: [Comment] = []
    @Published var isLoading = false
    @Published var isPosting = false
    @Published var inDeletion: String?
    
    private let commentService: CommentService
    private var commentsCancellable: AnyCancellable?
    
    init(code: DodoCode, commentService: CommentService = .shared) {
        self.code = code
        self.commentService = commentService
        
        if let record = code.record {
            self.commentsCancellable = commentService.$comments.sink { comments in
                DispatchQueue.main.async {
                    self.comments = comments[record.recordID] ?? []
                    self.isLoading = false
                    self.isPosting = false
                    self.inDeletion = nil
                }
            }
        }
    }
    
    func fetchComments() {
        isLoading = true
        if let record = code.record {
            commentService.fetchComments(record: record)
        }
    }
    
    func addComment(comment: Comment) {
        isPosting = true
        if let record = code.record {
            commentService.addComment(comment: comment,
                                      owner: record)
        }
    }
    
    func deleteComment(comment: Comment) {
        if let record = code.record {
            isLoading = true
            inDeletion = comment.id
            commentService.deleteComment(comment: comment,
                                         owner: record)
        }
    }
    
}
