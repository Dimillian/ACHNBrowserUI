//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 15/06/2020.
//

import Foundation
import CloudKit

public struct Comment: CloudModel, Equatable, Identifiable {
    public static var RecordType = "ACComment"
    
    public let id: String
    public let text: String
    public let name: String
    public let islandName: String
    public let isMine: Bool

    public var record: CKRecord?
    public var owner: CKRecord.Reference?
    
    public var creationDate: Date {
        record?.creationDate ?? Date()
    }
    
    enum RecordKeys: String {
        case id, text, name, islandName, owner
    }
    
    public init(text: String, name: String, islandName: String) {
        self.id = UUID().uuidString
        self.text = text
        self.name = name
        self.islandName = islandName
        self.isMine = true
    }
    
    public init(withRecord record: CKRecord) {
        self.id = record[RecordKeys.id.rawValue] as? String ?? ""
        self.name = record[RecordKeys.name.rawValue] as? String ?? ""
        self.islandName = record[RecordKeys.islandName.rawValue] as? String ?? ""
        self.text = record[RecordKeys.text.rawValue] as? String ?? ""
        self.owner = record[RecordKeys.owner.rawValue] as? CKRecord.Reference
        self.isMine = record.creatorUserRecordID?.recordName.contains("defaultOwner") == true
        self.record = record
    }
    
    public func toRecord(owner: CKRecord?) -> CKRecord {
        let record = self.record ?? CKRecord(recordType: Self.RecordType)
        record[RecordKeys.id.rawValue] = id
        record[RecordKeys.text.rawValue] = text
        record[RecordKeys.name.rawValue] = name
        record[RecordKeys.islandName.rawValue] = islandName
        if let owner = owner {
            record[RecordKeys.owner.rawValue] = CKRecord.Reference(record: owner, action: .deleteSelf)
        }
        return record
    }
}
