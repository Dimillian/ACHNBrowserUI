//
//  CollectionViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import CloudKit

public class UserCollection: ObservableObject {
    public static let shared = UserCollection(iCloudDisabled: false)
    
    // MARK: - Published properties
    @Published public var items: [Item] = []
    @Published public var villagers: [Villager] = []
    @Published public var critters: [Item] = []
    @Published public var lists: [UserList] = []
    @Published public var dailyTasks = DailyTasks()
    @Published public var isCloudEnabled = true
    @Published public var isSynched = false
    
    // MARK: - Private properties
    private struct SavedData: Codable {
        let items: [Item]
        let villagers: [Villager]
        let critters: [Item]
        let lists: [UserList]?
        let dailyTasks: DailyTasks?
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private static let recordType = "UserCollection"
    private static let recordId = CKRecord.ID(recordName: "CurrentUserCollection")
    private static let assetKey = "data"
    private var cloudKitDatabase: CKDatabase? = nil
    private var currentRecord: CKRecord? = nil
    
    public init(iCloudDisabled: Bool) {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("collection")
            _ = self.loadCollection(file: filePath)
            
            if !iCloudDisabled {
                checkiCloudStatus()
            } else {
                isCloudEnabled = false
            }
                        
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Items management
    public func itemsIn(category: Category) -> Int {
        let items = Items.shared.categories[category] ?? []
        var caught = self.critters.count(where: { items.contains($0) } )
        caught += self.items.count(where: { items.contains($0) && !$0.name.contains("(fake)") })
        return caught
    }

    public func toggleItem(item: Item) -> Bool {
        let added = items.toggle(item: item)
        save()
        return added
    }
    
    public func toggleCritters(critter: Item) -> Bool {
        let added = critters.toggle(item: critter)
        save()
        return added
    }
    
    public func toggleVillager(villager: Villager) -> Bool {
        var added = false
        if villagers.contains(villager) {
            villagers.removeAll(where: { $0 == villager })
        } else {
            villagers.append(villager)
            added = true
        }
        save()
        return added
    }
    
    public func
        updateProgress(taskName: DailyTasks.taskName) {
        dailyTasks.tasks[taskName]?.curProgress += 1
        dailyTasks.lastUpdate = Date()
        save()
    }
    
    public func resetTasks() {
        dailyTasks.lastUpdate = Date()
        for(taskName, _) in dailyTasks.tasks {
            dailyTasks.tasks[taskName]?.curProgress = 0
        }
        save()
    }
    
    // MARK: - User items list
    public func addList(userList: UserList) {
        lists.append(userList)
        save()
    }
    
    public func editList(userList: UserList) {
        let index = lists.firstIndex(where: { $0.id == userList.id} )!
        lists[index] = userList
        save()
    }
    
    public func deleteList(at index: Int) {
        lists.remove(at: index)
        save()
    }
    
    public func addItems(for list: UUID, items: [Item]) {
        let index = lists.firstIndex(where: { $0.id == list })!
        lists[index].items.append(contentsOf: items)
        save()
    }
    
    public func deleteItem(for list: UUID, at: Int) {
        let index = lists.firstIndex(where: { $0.id == list })!
        lists[index].items.remove(at: at)
        save()
    }
    
    // MARK: - CloudKit
    private func checkiCloudStatus() {
        CKContainer.default().accountStatus { (status, error) in
            if error != nil || status != .available {
                DispatchQueue.main.async {
                    self.isCloudEnabled = false
                }
            } else {
                self.cloudKitDatabase = CKContainer.default().privateCloudDatabase
                self.reloadFromCloudKit()
                self.subscribeToCloudKit()
            }
        }
    }
    
    private func subscribeToCloudKit() {
        cloudKitDatabase?.fetchAllSubscriptions { (subs, _) in
            if subs == nil || subs?.isEmpty == true {
                self.createSubscription()
            }
        }
    }
    
    private func createSubscription() {
        let sub = CKQuerySubscription(recordType: Self.recordType,
                                      predicate: NSPredicate(value: true),
                                      options: .firesOnRecordUpdate)
        let notif = CKSubscription.NotificationInfo()
        notif.shouldSendContentAvailable = true
        sub.notificationInfo = notif
        cloudKitDatabase?.save(sub) { (_, _) in }
    }
    
    public func reloadFromCloudKit() {
        cloudKitDatabase?.fetch(withRecordID: Self.recordId) { (record, error) in
            if record == nil {
                DispatchQueue.main.async {
                    self.save()
                }
            } else {
                self.currentRecord = record
                if let asset = record?[Self.assetKey] as? CKAsset,
                    let url = asset.fileURL {
                    DispatchQueue.main.async {
                        self.isSynched = true
                        _ = self.loadCollection(file: url)
                        try? FileManager.default.removeItem(at: self.filePath)
                        try? FileManager.default.copyItem(at: url, to: self.filePath)
                    }
                }
            }
        }
    }
    
    private func saveToCloudKit() {
        if let record = currentRecord {
            record[Self.assetKey] = CKAsset(fileURL: filePath)
            let modified = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
            modified.savePolicy = .allKeys
            modified.completionBlock = {
                DispatchQueue.main.async {
                    self.isSynched = true
                }
            }
            cloudKitDatabase?.add(modified)
        } else {
            let record = CKRecord(recordType: Self.recordType,
                                  recordID: Self.recordId)
            let asset = CKAsset(fileURL: filePath)
            record[Self.assetKey] = asset
            
            cloudKitDatabase?.save(record) { (record, error) in
                DispatchQueue.main.async {
                    self.currentRecord = record
                    self.isSynched = true
                }
            }
        }
    }
    
    // MARK: - Import / Export
    private func save() {
        do {
            let savedData = SavedData(items: items, villagers: villagers, critters: critters, lists: lists, dailyTasks: dailyTasks)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        
            if isCloudEnabled {
                isSynched = false
                saveToCloudKit()
            }
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
    
    private func loadCollection(file: URL) -> Bool {
        if let data = try? Data(contentsOf: file) {
            decoder.dataDecodingStrategy = .base64
            do {
                let savedData = try decoder.decode(SavedData.self, from: data)
                self.items = savedData.items
                self.villagers = savedData.villagers
                self.critters = savedData.critters
                self.lists = savedData.lists ?? []
                self.dailyTasks = savedData.dailyTasks ?? DailyTasks()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    public func deleteCollection() -> Bool {
        do {
            try FileManager.default.removeItem(at: filePath)
            self.items = []
            self.villagers = []
            self.critters = []
            self.lists = []
            self.dailyTasks = DailyTasks()
            save()
            return true
        } catch {
            return false
        }
    }
    
    public func generateExportURL() -> URL? {
        do {
            var sharedURL = try FileManager.default.url(for: .documentDirectory,
                                                                    in: .userDomainMask,
                                                                    appropriateFor: nil,
                                                                    create: false)
            sharedURL.appendPathComponent("exported-collection")
            sharedURL.appendPathExtension("achelper")
            try? FileManager.default.removeItem(at: sharedURL)
            try FileManager.default.copyItem(at: filePath, to: sharedURL)
            return sharedURL
        } catch let error {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func sizeOfArchivedState() -> String {
        do {
            let resources = try filePath.resourceValues(forKeys:[.fileSizeKey])
            let formatter = ByteCountFormatter()
            formatter.allowedUnits = .useKB
            formatter.countStyle = .file
            return formatter.string(fromByteCount: Int64(resources.fileSize ?? 0))
        } catch {
            return "0"
        }
    }
    
    public func processImportedFile(url: URL) -> Bool {
        let success = loadCollection(file: url)
        if success {
            save()
        }
        return success
    }
}
