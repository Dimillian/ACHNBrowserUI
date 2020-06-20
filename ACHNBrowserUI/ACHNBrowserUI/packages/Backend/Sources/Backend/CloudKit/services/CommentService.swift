//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 15/06/2020.
//

import Foundation
import CloudKit

public class CommentService: ObservableObject, PublicCloudService {
    
    // MARK: - Vars
    public static let shared = CommentService()
    
    @Published public var comments: [CKRecord.ID: [Comment]] = [:]
    @Published public var mostRecentError: Error?
    @Published public var canPostComment = false
    
    init() {
        CKContainer.default().accountStatus { (status, error) in
            DispatchQueue.main.async {
                self.canPostComment = status == .available
            }
        }
    }
    
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
        database.add(operation)
    }
    
    public func fetchComments(record: CKRecord) {
        let reference = CKRecord.Reference(record: record, action: .deleteSelf)
        let predicate = NSPredicate(format: "owner = %@", reference)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: Comment.RecordType, predicate: predicate)
        query.sortDescriptors = [sort]
        database.perform(query, inZoneWith: nil) { (records, error) in
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
            database.add(operation)
        }
    }
    
    public func subscribeNotificationsForOwner(owner: CKRecord) {
        let predicate = NSPredicate(format: "owner = %@", owner.recordID)
        let subscription = CKQuerySubscription(recordType: Comment.RecordType,
                                               predicate: predicate,
                                               options: .firesOnRecordCreation)
        let notif = CKSubscription.NotificationInfo()
        notif.titleLocalizationKey = "ACComment.notification.title"
        notif.alertLocalizationKey = "ACComment.notification.subtitle"
        notif.soundName = "default"
        subscription.notificationInfo = notif
        database.save(subscription) { (_, _) in
            
        }
    }
    
    public func deleteNotificationSubscriptionFor(owner: CKRecord) {
        let predicate = NSPredicate(format: "owner = %@", owner.recordID)
        database.fetchAllSubscriptions { (subs, _) in
            if let subs = subs, let sub = subs.first(where: { (sub) -> Bool in
                if let sub = sub as? CKQuerySubscription {
                    return sub.recordType == Comment.RecordType && sub.predicate == predicate
                }
                return false
            }) {
                let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil,
                                                               subscriptionIDsToDelete: [sub.subscriptionID])
                self.database.add(operation)
            }
        }
    }
    
    private func setError(error: Error?) {
        DispatchQueue.main.async {
            self.mostRecentError = error
        }
    }
}
