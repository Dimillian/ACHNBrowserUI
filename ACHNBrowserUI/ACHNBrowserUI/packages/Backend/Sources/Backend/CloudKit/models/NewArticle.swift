//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 19/06/2020.
//

import Foundation
import CloudKit

public struct NewArticle: CloudModel, Equatable, Identifiable {
    public static var RecordType = "ACNewArticle"
    
    public var id: Int {
        (title + content).hashValue
    }
    
    public let title: String
    public let content: String
    public var upvotes: Int
    public var creationDate: Date {
        record?.creationDate ?? Date()
    }
    public var record: CKRecord?
    
    
    enum RecordKeys: String {
        case title, content, upvotes
    }
    
    public init(withRecord record: CKRecord) {
        title = record[RecordKeys.title.rawValue] as? String ?? ""
        content = record[RecordKeys.content.rawValue] as? String ?? ""
        upvotes = record[RecordKeys.upvotes.rawValue] as? Int ?? 0
        self.record = record
    }
    
    public func toRecord(owner: CKRecord?) -> CKRecord {
        let record = self.record ?? CKRecord(recordType: Self.RecordType)
        record[RecordKeys.title.rawValue] = title
        record[RecordKeys.content.rawValue] = content
        record[RecordKeys.upvotes.rawValue] = upvotes
        return record
    }
}
