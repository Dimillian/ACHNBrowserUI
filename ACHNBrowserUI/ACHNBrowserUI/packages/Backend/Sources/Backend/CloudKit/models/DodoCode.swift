//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 12/06/2020.
//

import Foundation
import CloudKit

public struct DodoCode: CloudModel, Identifiable, Equatable {
    public static var RecordType = "ACDodoCode"
    
    public static func == (lhs: DodoCode, rhs: DodoCode) -> Bool {
        lhs.id == rhs.id &&
        lhs.upvotes == rhs.upvotes &&
        lhs.code == rhs.code &&
        lhs.islandName == rhs.islandName &&
        lhs.text == rhs.text &&
        lhs.fruit == rhs.fruit &&
        lhs.hemisphere == rhs.hemisphere &&
        lhs.specialCharacter == rhs.specialCharacter &&
        lhs.archived == rhs.archived
    }
    
    public let id: String
    public let code: String
    public var report: Int
    public var upvotes: Int
    public let islandName: String
    public let text: String
    public let fruit: Fruit
    public let hemisphere: Hemisphere
    public let specialCharacter: SpecialCharacters?
    public let archived: Bool
    public let isMine: Bool
    public var creationDate: Date {
        record?.creationDate ?? Date()
    }
    public var record: CKRecord?
    
    enum RecordKeys: String {
        case id, code, report, upvotes, islandName, text, fruit, hemisphere, specialCharacter, archived
    }
    
    public init(code: String, islandName: String, text: String,
                fruit: Fruit, hemisphere: Hemisphere, specialCharacter: SpecialCharacters? = nil) {
        self.id = UUID().uuidString
        self.code = code
        self.islandName = islandName
        self.text = text
        self.fruit = fruit
        self.hemisphere = hemisphere
        self.specialCharacter = specialCharacter
        self.report = 0
        self.upvotes = 0
        self.archived = false
        self.isMine = true
    }
    
    public init(withRecord record: CKRecord) {
        id = record[RecordKeys.id.rawValue] as? String ?? ""
        code = record[RecordKeys.code.rawValue] as? String ?? ""
        report = record[RecordKeys.report.rawValue] as? Int ?? 0
        upvotes = record[RecordKeys.upvotes.rawValue] as? Int ?? 0
        islandName = record[RecordKeys.islandName.rawValue] as? String ?? ""
        text = record[RecordKeys.text.rawValue] as? String ?? ""
        fruit = Fruit(rawValue: record[RecordKeys.fruit.rawValue] as? String ?? "") ?? .apple
        hemisphere = Hemisphere(rawValue: record[RecordKeys.hemisphere.rawValue] as? String ?? "") ?? .north
        specialCharacter = SpecialCharacters(rawValue: record[RecordKeys.specialCharacter.rawValue] as? String ?? "")
        archived = record[RecordKeys.archived.rawValue] as? Bool ?? false
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
        record[RecordKeys.fruit.rawValue] = fruit.rawValue
        record[RecordKeys.hemisphere.rawValue] = hemisphere.rawValue
        record[RecordKeys.archived.rawValue] = archived
        if let specialCharacter = specialCharacter {
            record[RecordKeys.specialCharacter.rawValue] = specialCharacter.rawValue
        }
        return record
    }
}

public let static_dodoCode = DodoCode(code: "8CUET",
                                      islandName: "Viridian",
                                      text: "I have Saharah, you're welcome and no entry fee",
                                      fruit: .orange,
                                      hemisphere: .north)
