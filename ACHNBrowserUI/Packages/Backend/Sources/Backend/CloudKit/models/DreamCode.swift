//
//  DreamCode.swift
//  
//
//  Created by Jan van Heesch on 02.08.20.
//

import Foundation
import CloudKit

public struct DreamCode: CloudModel, Identifiable, Equatable {
    public static var RecordType = "ACDreamCode"
    
    public static func == (lhs: DreamCode, rhs: DreamCode) -> Bool {
        lhs.id == rhs.id &&
        lhs.upvotes == rhs.upvotes &&
        lhs.code == rhs.code &&
        lhs.islandName == rhs.islandName &&
        lhs.text == rhs.text &&
        lhs.hemisphere == rhs.hemisphere
    }
    
    public let id: String
    public let code: String
    public var report: Int
    public var upvotes: Int
    public let islandName: String
    public let text: String
    public let hemisphere: Hemisphere
    public let isMine: Bool
    public var creationDate: Date {
        record?.creationDate ?? Date()
    }
    public var record: CKRecord?
    
    enum RecordKeys: String {
        case id, code, report, upvotes, islandName, text, fruit, hemisphere
    }
    
    public init(code: String, islandName: String, text: String, hemisphere: Hemisphere) {
        self.id = UUID().uuidString
        self.code = code
        self.islandName = islandName
        self.text = text
        self.hemisphere = hemisphere
        self.report = 0
        self.upvotes = 0
        self.isMine = true
    }
    
    public init(withRecord record: CKRecord) {
        id = record[RecordKeys.id.rawValue] as? String ?? ""
        code = record[RecordKeys.code.rawValue] as? String ?? ""
        report = record[RecordKeys.report.rawValue] as? Int ?? 0
        upvotes = record[RecordKeys.upvotes.rawValue] as? Int ?? 0
        islandName = record[RecordKeys.islandName.rawValue] as? String ?? ""
        text = record[RecordKeys.text.rawValue] as? String ?? ""
        hemisphere = Hemisphere(rawValue: record[RecordKeys.hemisphere.rawValue] as? String ?? "") ?? .north
        isMine = record.creatorUserRecordID?.recordName.contains("defaultOwner") == true
        self.record = record
    }
    
    public func toRecord(owner: CKRecord?) -> CKRecord {
        let record = self.record ?? CKRecord(recordType: Self.RecordType)
        record[RecordKeys.id.rawValue] = id
        record[RecordKeys.code.rawValue] = code
        record[RecordKeys.report.rawValue] = report
        record[RecordKeys.upvotes.rawValue] = upvotes
        record[RecordKeys.islandName.rawValue] = islandName
        record[RecordKeys.text.rawValue] = text
        record[RecordKeys.hemisphere.rawValue] = hemisphere.rawValue
        return record
    }
}

public let static_dreamCode = DreamCode(code: "DA-1234-1234-1234",
                                      islandName: "Crispyisland",
                                      text: "Come and visit my island in your dreams!",
                                      hemisphere: .north)
