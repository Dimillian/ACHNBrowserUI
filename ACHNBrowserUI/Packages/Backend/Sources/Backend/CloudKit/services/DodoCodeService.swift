//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 12/06/2020.
//

import Foundation
import CloudKit
import SwiftUI

public class DodoCodeService: ObservableObject, PublicCloudService {
    
    // MARK: - Vars
    public static let shared = DodoCodeService()
    public static var userCloudKitId: CKRecord.ID?
    
    public static let titleLocalizationKey = "ACDodoCode.notification.title"
    public static let alertLocalizationKey = "ACDodoCode.notification.subtitle"
    
    @Published public var codes: [DodoCode] = []
    @Published public var mostRecentError: Error?
    @Published public var isSynching = true
    @Published public var canAddCode = false
    
    private var reported: [DodoCode] = []
    
    init() {
        CKContainer.default().accountStatus { (status, error) in
            DispatchQueue.main.async {
                self.canAddCode = status == .available
            }
        }
        
        CKContainer.default().fetchUserRecordID { (id, error) in
            Self.userCloudKitId = id
        }
        
        if AppUserDefaults.shared.dodoNotifications {
            subscribeToCloudKit()
        }
    }
    
    // MARK: - Public
    public func refresh() {
        fetchCodes()
    }
    
        
    public func add(code: DodoCode) {
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
    
    public func edit(code: DodoCode) {
        isSynching = true
        let operation = CKModifyRecordsOperation(recordsToSave: [code.toRecord(owner: nil)],
                                                 recordIDsToDelete: nil)
        addOperation(operation: operation, fetch: true)
    }
    
    public func upvote(code: DodoCode) {
        if let record = code.record {
            record[DodoCode.RecordKeys.upvotes.rawValue] = code.upvotes + 1
            let operation = CKModifyRecordsOperation(recordsToSave: [record],
                                                     recordIDsToDelete: nil)
            addOperation(operation: operation, fetch: true)
        }
    }
    
    public func report(code: DodoCode) {
        if let record = code.record,
            var reports = record[DodoCode.RecordKeys.report.rawValue] as? Int {
            reports += 1
            record[DodoCode.RecordKeys.report.rawValue] = reports
            let operation = CKModifyRecordsOperation(recordsToSave: [record],
                                                     recordIDsToDelete: nil)
            self.reported.append(code)
            addOperation(operation: operation, fetch: true)
        }
    }
    
    public func delete(code: DodoCode) {
        codes.removeAll(where: { code.id == $0.id })
        if let record = code.record {
            CommentService.shared.deleteNotificationSubscriptionFor(owner: record)
            let operation = CKModifyRecordsOperation(recordsToSave: nil,
                                                     recordIDsToDelete: [record.recordID])
            addOperation(operation: operation, fetch: false)
        }
    }
    
    public func toggleArchive(code: DodoCode) {
        if let record = code.record {
            record[DodoCode.RecordKeys.archived.rawValue] = !code.archived
            let operation = CKModifyRecordsOperation(recordsToSave: [record],
                                                     recordIDsToDelete: nil)
            addOperation(operation: operation, fetch: true)
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
            if self.serviceSubscriptionExist(recordType: DodoCode.RecordType, subs: subs) == nil {
                self.createSubscription()
            }
        }
    }
    
    private func createSubscription() {
        let sub = CKQuerySubscription(recordType: DodoCode.RecordType,
                                      predicate: NSPredicate(value: true),
                                      options: .firesOnRecordCreation)
        let notif = CKSubscription.NotificationInfo()
        notif.titleLocalizationKey = Self.titleLocalizationKey
        notif.alertLocalizationKey = Self.alertLocalizationKey
        notif.soundName = "default"
        sub.notificationInfo = notif
        database.save(sub) { (_, _) in }
    }
    
    private func deleteSubscriptions() {
        database.fetchAllSubscriptions { (subs, _) in
            if let sub = self.serviceSubscriptionExist(recordType: DodoCode.RecordType, subs: subs) {
                let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil,
                                                               subscriptionIDsToDelete: [sub.subscriptionID])
                self.database.add(operation)
            }
        }
    }
    
    private func fetchCodes() {
        isSynching = true
        let query = CKQuery(recordType: DodoCode.RecordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        database.perform(query, inZoneWith: nil) { (records, error) in
            self.setError(error: error)
            if let records = records {
                var nativeRecords: [DodoCode] = []
                for record in records {
                    nativeRecords.append(DodoCode(withRecord: record))
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
