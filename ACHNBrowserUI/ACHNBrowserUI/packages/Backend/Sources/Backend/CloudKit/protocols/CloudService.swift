//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 16/06/2020.
//

import Foundation
import CloudKit

protocol PublicCloudService {
    var database: CKDatabase { get }
}

extension PublicCloudService {
    var database: CKDatabase {
        CKContainer.default().publicCloudDatabase
    }
}
