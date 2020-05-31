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
import os.log

public class UserCollection: ObservableObject {
    public static let shared = UserCollection(iCloudDisabled: false)
    
    // MARK: - Published properties
    @Published public var items: [Item] = []
    @Published public var variants: [String: [Variant]] = [:]
    @Published public var villagers: [Villager] = []
    @Published public var critters: [Item] = []
    @Published public var lists: [UserList] = []
    @Published public var designs: [Design] = []
    @Published public var dailyTasks = DailyTasks()
    @Published public var chores: [Chore] = []
    
    @Published public var isCloudEnabled = true
    @Published public var isSynched = false
    
    // MARK: - Private properties
    private struct SavedData: Codable {
        let items: [Item]
        let variants: [String: [Variant]]?
        let villagers: [Villager]
        let critters: [Item]
        let lists: [UserList]?
        let dailyTasks: DailyTasks?
        let designs: [Design]?
        let chores: [Chore]?
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let saveQueue = DispatchQueue(label: "achelper.save.queue")
    
    private static let recordType = "UserCollection"
    private static let recordId = CKRecord.ID(recordName: "CurrentUserCollection")
    private static let assetKey = "data"
    private var cloudKitDatabase: CKDatabase? = nil
    private var currentRecord: CKRecord? = nil
    
    private let logHandler = OSLog(subsystem: "com.achelper.collection", category: "ac-perf")
    
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
    public func itemsIn(category: Category, items: [Item]) -> Int {
        os_signpost(.begin,
                    log: logHandler,
                    name: "Counting items with passed array",
                    "Begin for category %{public}s",
                    category.rawValue)
        
        let allItems = Items.shared.categories[category] ?? []
        let inCollection = items.count(where: { allItems.contains($0) && !$0.name.contains("(fake)") })
        
        os_signpost(.end,
                    log: logHandler,
                    name: "Counting items with passed array",
                    "Done for category %{public}s",
                    category.rawValue)
        
        return inCollection
    }
    
    public func itemsIn(category: Category) -> Int {
        os_signpost(.begin,
                    log: logHandler,
                    name: "Counting items",
                    "Begin for category %{public}s",
                    category.rawValue)
        
        let items = Items.shared.categories[category] ?? []
        var caught = self.critters.count(where: { items.contains($0) } )
        caught += self.items.count(where: { items.contains($0) && !$0.name.contains("(fake)") })
        
        os_signpost(.end,
                    log: logHandler,
                    name: "Counting items",
                    "Done for category %{public}s",
                    category.rawValue)
        
        return caught
    }

    public func toggleItem(item: Item) -> Bool {
        let added = items.toggle(item: item)
        save()
        return added
    }
    
    public func variantIn(item: Item, variant: Variant) -> Bool {
        guard let filename = item.filename else {
            return false
        }
        return variants[filename]?.contains(variant) == true
    }
    
    public func toggleVariant(item: Item, variant: Variant) -> Bool {
        guard let filename = item.filename else {
            return false
        }
        if variants[filename]?.contains(variant) == true {
            variants[filename]?.removeAll(where: { $0 == variant })
            save()
            return false
        } else {
            if variants[filename] == nil {
                variants[filename] = []
            }
            variants[filename]?.append(variant)
            save()
            return true
        }
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
    
    public func updateProgress(taskName: DailyTasks.taskName) {
        dailyTasks.tasks[taskName]?.curProgress += 1
        dailyTasks.lastUpdate = Date()
        save()
    }

    public func resetProgress(taskName: DailyTasks.taskName) {
        dailyTasks.tasks[taskName]?.curProgress = 0
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

    // MARK: - Custom Designs

    public func addDesign(_ design: Design) {
        designs.append(design)
        save()
    }

    public func deleteDesign(at index: Int) {
        designs.remove(at: index)
        save()
    }

    // MARK: - Chores

    public func addChore(_ task: Chore) {
        chores.append(task)
        save()
    }

    public func deleteChore(at index: Int) {
        chores.remove(at: index)
        save()
    }

    public func toggleChore(_ task: Chore) {
        guard let index = chores.firstIndex(of: task) else { return }
        chores[index].isFinished.toggle()
        save()
    }

    public func resetChores() {
        for index in 0..<chores.count {
            chores[index].isFinished = false
        }
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
        saveQueue.async { [weak self] in
            guard let weakself = self else { return }
            do {
                let savedData = SavedData(items: weakself.items,
                                          variants: weakself.variants,
                                          villagers: weakself.villagers,
                                          critters: weakself.critters,
                                          lists: weakself.lists,
                                          dailyTasks: weakself.dailyTasks,
                                          designs: weakself.designs,
                                          chores: weakself.chores)
                let data = try weakself.encoder.encode(savedData)
                try data.write(to: weakself.filePath, options: .atomicWrite)
                
                if weakself.isCloudEnabled {
                    DispatchQueue.main.async {
                        weakself.isSynched = false
                        weakself.saveToCloudKit()
                    }
                }
            } catch let error {
                print("Error while saving collection: \(error.localizedDescription)")
            }
            weakself.encoder.dataEncodingStrategy = .base64
        }
    }
    
    private func loadCollection(file: URL) -> Bool {
        if let data = try? Data(contentsOf: file) {
            decoder.dataDecodingStrategy = .base64
            do {
                let savedData = try decoder.decode(SavedData.self, from: data)
                self.items = savedData.items
                self.variants = savedData.variants ?? [:]
                self.villagers = savedData.villagers
                self.critters = savedData.critters
                self.lists = savedData.lists ?? []
                self.dailyTasks = savedData.dailyTasks ?? DailyTasks()
                self.designs = savedData.designs ?? []
                self.chores = savedData.chores ?? []
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
            self.designs = []
            self.chores = []
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
