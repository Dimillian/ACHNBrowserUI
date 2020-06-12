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
    }
    
    // MARK: - Public
    public func refresh() {
        fetchCodes()
    }
    
    public func addDodoCode(code: DodoCode) {
        isSynching = true
        let record = code.toRecord()
        var code = code
        cloudKitDatabase.save(record) { (record, error) in
            DispatchQueue.main.async {
                if let record = record {
                    code.canDelete = true
                    code.record = record
                    self.codes.insert(code, at: 0)
                }
                self.isSynching = false
                self.setError(error: error)
            }
        }
    }
    
    public func reportDodocode(code: DodoCode) {
        if let record = code.record,
            var reports = record[DodoCode.RecordKeys.report.rawValue] as? Int {
            var delete = false
            if reports >= 2 {
                delete = true
            } else {
                reports += 1
                record[DodoCode.RecordKeys.report.rawValue] = reports
                
            }
            let operation = CKModifyRecordsOperation(recordsToSave: delete ? nil : [record],
                                                     recordIDsToDelete: delete ? [record.recordID] : nil)
            operation.modifyRecordsCompletionBlock = { _, _, error in
                DispatchQueue.main.async {
                    self.reported.append(code)
                    self.setError(error: error)
                    self.fetchCodes()
                }
            }
            self.cloudKitDatabase.add(operation)
        }
    }
    
    public func deleteDodoCode(code: DodoCode) {
        codes.removeAll(where: { code.id == $0.id })
        if let record = code.record {
            let operation = CKModifyRecordsOperation(recordsToSave: nil,
                                                     recordIDsToDelete: [record.recordID])
            operation.modifyRecordsCompletionBlock = { _, _, error in
                DispatchQueue.main.async {
                    self.setError(error: error)
                }
            }
            self.cloudKitDatabase.add(operation)
        }
    }
    
    // MARK: - Private
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
