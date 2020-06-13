//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 12/06/2020.
//

import Foundation
import CloudKit

public struct DodoCode: Identifiable, Equatable {
    public static func == (lhs: DodoCode, rhs: DodoCode) -> Bool {
        lhs.id == rhs.id && lhs.upvotes == rhs.upvotes
    }
    
    public let id: String
    public let code: String
    public let report: Int
    public let upvotes: Int
    public let islandName: String
    public let text: String
    public let fruit: Fruit
    public let hemisphere: Hemisphere
    public var canDelete = false
    public var creationDate: Date {
        record?.creationDate ?? Date()
    }
    public var record: CKRecord?
    
    enum RecordKeys: String {
        case id, code, report, upvotes, islandName, text, fruit, hemisphere
    }
    
    public init(code: String, islandName: String, text: String, fruit: Fruit, hemisphere: Hemisphere) {
        self.id = UUID().uuidString
        self.code = code
        self.islandName = islandName
        self.text = text
        self.fruit = fruit
        self.hemisphere = hemisphere
        self.report = 0
        self.upvotes = 0
    }
    
    init(withRecord record: CKRecord) {
        id = record[RecordKeys.id.rawValue] as? String ?? ""
        code = record[RecordKeys.code.rawValue] as? String ?? ""
        report = record[RecordKeys.report.rawValue] as? Int ?? 0
        upvotes = record[RecordKeys.upvotes.rawValue] as? Int ?? 0
        islandName = record[RecordKeys.islandName.rawValue] as? String ?? ""
        text = record[RecordKeys.text.rawValue] as? String ?? ""
        fruit = Fruit(rawValue: record[RecordKeys.fruit.rawValue] as? String ?? "") ?? .apple
        hemisphere = Hemisphere(rawValue: record[RecordKeys.hemisphere.rawValue] as? String ?? "") ?? .north
        canDelete = record.creatorUserRecordID?.recordName.contains("defaultOwner") == true
        self.record = record
    }
    
    func toRecord() -> CKRecord {
        let record = CKRecord(recordType: DodoCodeService.recordType)
        record[RecordKeys.id.rawValue] = id
        record[RecordKeys.code.rawValue] = code
        record[RecordKeys.report.rawValue] = report
        record[RecordKeys.upvotes.rawValue] = upvotes
        record[RecordKeys.islandName.rawValue] = islandName
        record[RecordKeys.text.rawValue] = text
        record[RecordKeys.fruit.rawValue] = fruit.rawValue
        record[RecordKeys.hemisphere.rawValue] = hemisphere.rawValue
        return record
    }
}

public let static_dodoCode = DodoCode(code: "8CUET",
                                      islandName: "Viridian",
                                      text: "I have Saharah, you're welcome and no entry fee",
                                      fruit: .orange,
                                      hemisphere: .north)
