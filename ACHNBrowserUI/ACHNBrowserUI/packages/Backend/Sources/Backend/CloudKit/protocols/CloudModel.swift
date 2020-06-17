//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 16/06/2020.
//

import Foundation
import CloudKit

protocol CloudModel {
    static var RecordType: String { get }
    init(withRecord record: CKRecord)
    func toRecord(owner: CKRecord?) -> CKRecord
}
