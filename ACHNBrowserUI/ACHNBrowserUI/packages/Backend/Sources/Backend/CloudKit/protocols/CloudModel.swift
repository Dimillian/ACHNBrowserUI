//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 16/06/2020.
//

import Foundation
import CloudKit

public protocol CloudModel {
    static var RecordType: String { get }
    var record: CKRecord? { get }
    init(withRecord record: CKRecord)
    func toRecord(owner: CKRecord?) -> CKRecord
}
