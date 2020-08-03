//
//  DreamCodeService.swift
//  
//
//  Created by Jan van Heesch on 02.08.20.
//

import Foundation
import CloudKit
import SwiftUI

public class DreamCodeService: ObservableObject, PublicCloudService {
    
    // MARK: - Vars
    public static let shared = DreamCodeService()
    
    public enum Sort: String, CaseIterable {
        case creationDate, upvotes
    }

    @Published public var codes: [DreamCode] = []
    @Published public var mostRecentError: Error?
    @Published public var isSynching = true
    @Published public var canAddCode = false
    @Published public var sort = Sort.creationDate {
        didSet {
            refresh()
        }
    }
    
    private var reported: [DreamCode] = []
    
    init() {
        CKContainer.default().accountStatus { (status, error) in
            DispatchQueue.main.async {
                self.canAddCode = status == .available
            }
        }
                
        if AppUserDefaults.shared.dreamNotifications {
            subscribeToCloudKit()
        }
    }
    
    // MARK: - Public
    public func refresh() {
        fetchCodes()
    }
    
        
    public func add(code: DreamCode) {
        isSynching = true
        let record = code.toRecord(owner: nil)
        var code = code
        database.save(record) { (record, error) in
            DispatchQueue.main.async {
                if let record = record {
                    code.record = record
                    CommentService.shared.subscribeNotificationsForOwner(owner: record)
                    self.codes.insert(code, at: 0)
                }
                self.isSynching = false
                self.setError(error: error)
            }
        }
    }
    
    public func edit(code: DreamCode) {
        isSynching = true
        let operation = CKModifyRecordsOperation(recordsToSave: [code.toRecord(owner: nil)],
                                                 recordIDsToDelete: nil)
        addOperation(operation: operation, fetch: true)
    }
    
    public func upvote(code: DreamCode) {
        if let record = code.record {
            record[DreamCode.RecordKeys.upvotes.rawValue] = code.upvotes + 1
            let operation = CKModifyRecordsOperation(recordsToSave: [record],
                                                     recordIDsToDelete: nil)
            addOperation(operation: operation, fetch: true)
        }
    }
    
    public func report(code: DreamCode) {
        if let record = code.record,
            var reports = record[DreamCode.RecordKeys.report.rawValue] as? Int {
            reports += 1
            record[DreamCode.RecordKeys.report.rawValue] = reports
            let operation = CKModifyRecordsOperation(recordsToSave: [record],
                                                     recordIDsToDelete: nil)
            self.reported.append(code)
            addOperation(operation: operation, fetch: true)
        }
    }
    
    public func delete(code: DreamCode) {
        codes.removeAll(where: { code.id == $0.id })
        if let record = code.record {
            CommentService.shared.deleteNotificationSubscriptionFor(owner: record)
            let operation = CKModifyRecordsOperation(recordsToSave: nil,
                                                     recordIDsToDelete: [record.recordID])
            addOperation(operation: operation, fetch: false)
        }
    }
    
    public func enableNotifications() {
        subscribeToCloudKit()
    }
    
    public func disableNotifications() {
        deleteSubscriptions()
    }
    
    // MARK: - Private
    private func addOperation(operation: CKModifyRecordsOperation, fetch: Bool) {
        operation.modifyRecordsCompletionBlock = { _, _, error in
            DispatchQueue.main.async {
                self.setError(error: error)
                if fetch {
                    self.fetchCodes()
                }
            }
        }
        database.add(operation)
    }
    
    private func subscribeToCloudKit() {
        database.fetchAllSubscriptions { (subs, _) in
            if self.serviceSubscriptionExist(recordType: DreamCode.RecordType, subs: subs) == nil {
                self.createSubscription()
            }
        }
    }
    
    private func createSubscription() {
        let sub = CKQuerySubscription(recordType: DreamCode.RecordType,
                                      predicate: NSPredicate(value: true),
                                      options: .firesOnRecordCreation)
        let notif = CKSubscription.NotificationInfo()
        notif.titleLocalizationKey = "ACDreamCode.notification.title"
        notif.alertLocalizationKey = "ACDreamCode.notification.subtitle"
        notif.soundName = "default"
        sub.notificationInfo = notif
        database.save(sub) { (_, _) in }
    }
    
    private func deleteSubscriptions() {
        database.fetchAllSubscriptions { (subs, _) in
            if let sub = self.serviceSubscriptionExist(recordType: DreamCode.RecordType, subs: subs) {
                let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil,
                                                               subscriptionIDsToDelete: [sub.subscriptionID])
                self.database.add(operation)
            }
        }
    }
    
    private func fetchCodes() {
        isSynching = true
        let query = CKQuery(recordType: DreamCode.RecordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: sort.rawValue, ascending: false)]
        database.perform(query, inZoneWith: nil) { (records, error) in
            self.setError(error: error)
            if let records = records {
                var nativeRecords: [DreamCode] = []
                for record in records {
                    nativeRecords.append(DreamCode(withRecord: record))
                }
                DispatchQueue.main.async {
                    self.codes = nativeRecords.filter{ !self.reported.contains($0) }
                }
            } else {
                self.codes = []
            }
            DispatchQueue.main.async {
                self.isSynching = false
            }
        }
    }
    
    private func setError(error: Error?) {
        DispatchQueue.main.async {
            self.mostRecentError = error
        }
    }
}
