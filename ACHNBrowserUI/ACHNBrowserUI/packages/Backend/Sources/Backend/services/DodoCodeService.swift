//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 12/06/2020.
//

import Foundation
import CloudKit
import SwiftUI

public class DodoCodeService: ObservableObject {
    
    // MARK: - Vars
    public static let shared = DodoCodeService()
    public static let recordType = "ACDodoCode"
    public static var userCloudKitId: CKRecord.ID?
    
    @Published public var codes: [DodoCode] = []
    @Published public var mostRecentError: Error?
    @Published public var isSynching = true
    @Published public var canEdit = false
    
    private var reported: [DodoCode] = []
    
    private var cloudKitDatabase = CKContainer.default().publicCloudDatabase

    init() {
        CKContainer.default().accountStatus { (status, error) in
            DispatchQueue.main.async {
                self.canEdit = status == .available
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
        let record = code.toRecord()
        var code = code
        cloudKitDatabase.save(record) { (record, error) in
            DispatchQueue.main.async {
                if let record = record {
                    code.record = record
                    self.codes.insert(code, at: 0)
                }
                self.isSynching = false
                self.setError(error: error)
            }
        }
    }
    
    public func edit(code: DodoCode) {
        isSynching = true
        let operation = CKModifyRecordsOperation(recordsToSave: [code.toRecord()],
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
        self.cloudKitDatabase.add(operation)
    }
    
    private func subscribeToCloudKit() {
        cloudKitDatabase.fetchAllSubscriptions { (subs, _) in
            if subs == nil || subs?.isEmpty == true {
                self.createSubscription()
            }
        }
    }
    
    private func createSubscription() {
        let sub = CKQuerySubscription(recordType: Self.recordType,
                                      predicate: NSPredicate(value: true),
                                      options: .firesOnRecordCreation)
        let notif = CKSubscription.NotificationInfo()
        notif.titleLocalizationKey = "ACDodoCode.notification.title"
        notif.alertLocalizationKey = "ACDodoCode.notification.subtitle"
        notif.soundName = "default"
        sub.notificationInfo = notif
        cloudKitDatabase.save(sub) { (_, _) in }
    }
    
    private func deleteSubscriptions() {
        cloudKitDatabase.fetchAllSubscriptions { (subs, _) in
            if let subs = subs {
                let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil,
                                                               subscriptionIDsToDelete: subs.map{ $0.subscriptionID })
                self.cloudKitDatabase.add(operation)
            }
        }
    }
    
    private func fetchCodes() {
        isSynching = true
        let query = CKQuery(recordType: Self.recordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        cloudKitDatabase.perform(query, inZoneWith: nil) { (records, error) in
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
