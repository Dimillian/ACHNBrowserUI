//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 15/06/2020.
//

import Foundation
import CloudKit

public class CommentService: ObservableObject {
    
    // MARK: - Vars
    public static let shared = CommentService()
    public static let recordType = "ACComment"
    
    @Published public var comments: [CKRecord.ID: [Comment]] = [:]
    @Published public var mostRecentError: Error?
    
    private var cloudKitDatabase = CKContainer.default().publicCloudDatabase
    
    public func addComment(comment: Comment, owner: CKRecord) {
        let record = comment.toRecord(owner: owner)
        var comment = comment
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        operation.modifyRecordsCompletionBlock = { saved, _, error in
            if let realRecord = saved?.first {
                comment.record = realRecord
                DispatchQueue.main.async {
                    if var comments = self.comments[owner.recordID] {
                        comments.insert(comment, at: 0)
                        self.comments[owner.recordID] = comments
                    } else {
                        self.comments[owner.recordID] = [comment]
                    }
                }
            }
            DispatchQueue.main.async {
                self.setError(error: error)
            }
        }
        cloudKitDatabase.add(operation)
    }
    
    public func fetchComments(record: CKRecord) {
        let reference = CKRecord.Reference(record: record, action: .deleteSelf)
        let predicate = NSPredicate(format: "owner == %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: Self.recordType, predicate: predicate)
        query.sortDescriptors = [sort]
        cloudKitDatabase.perform(query, inZoneWith: nil) { (records, error) in
            self.setError(error: error)
            if let records = records {
                let comments = records.map{ Comment(withRecord: $0) }
                DispatchQueue.main.async {
                    self.comments[record.recordID] = comments
                }
            }
        }
    }
    
    public func deleteComment(comment: Comment, owner: CKRecord) {
        if let record = comment.record {
            let operation = CKModifyRecordsOperation(recordsToSave: nil, recordIDsToDelete: [record.recordID])
            operation.modifyRecordsCompletionBlock = { _, _, _ in
                self.fetchComments(record: owner)
            }
            cloudKitDatabase.add(operation)
        }
    }
    
    private func setError(error: Error?) {
        DispatchQueue.main.async {
            self.mostRecentError = error
        }
    }
}
