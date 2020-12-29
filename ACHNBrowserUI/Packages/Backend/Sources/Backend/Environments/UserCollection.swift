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
import WidgetKit

public class UserCollection: ObservableObject {
    public static let shared = UserCollection(iCloudDisabled: false)
    
    // MARK: - Published properties
    @Published public var items: [Item] = []
    @Published public var variants: [String: [Variant]] = [:]
    @Published public var villagers: [Villager] = []
    @Published public var residents: [Villager] = []
    @Published public var visitedResidents: [Villager] = []
    @Published public var critters: [Item] = []
    @Published public var lists: [UserList] = []
    @Published public var designs: [Design] = []
    @Published public var dailyCustomTasks = DailyCustomTasks()
    @Published public var chores: [Chore] = []
    
    @Published public var isCloudEnabled = true
    @Published public var isSynched = false
    
    // MARK: - Private properties
    private struct SavedData: Codable {
        let items: [Item]
        let variants: [String: [Variant]]?
        let villagers: [Villager]
        let residents: [Villager]?
        let visitedResidents: [Villager]?
        let critters: [Item]
        let lists: [UserList]?
        let dailyCustomTasks: DailyCustomTasks?
        let designs: [Design]?
        let chores: [Chore]?
    }
    
    private let filePath: URL
    private let sharedFilePath: URL?
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    private let saveQueue = DispatchQueue(label: "achelper.save.queue")
    
    private static let recordType = "UserCollection"
    private static let recordId = CKRecord.ID(recordName: "CurrentUserCollection")
    private static let assetKey = "data"
    private var cloudKitDatabase: CKDatabase? = nil
    private var currentRecord: CKRecord? = nil
    
    private let logHandler = OSLog(subsystem: "com.achelper.collection", category: "ac-perf")
    
    public init(iCloudDisabled: Bool, fromSharedURL: Bool = false) {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("collection")
            sharedFilePath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.achelper.com")?.appendingPathComponent("collection")
            if fromSharedURL, let url = sharedFilePath {
                _ = self.loadCollection(file: url)
            } else {
                _ = self.loadCollection(file: filePath)
            }
            
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
    
    public func itemsIn(useItems: Bool = true, category: Category) -> Int {
        os_signpost(.begin,
                    log: logHandler,
                    name: "Counting items",
                    "Begin for category %{public}s",
                    category.rawValue)
        
        var items: [Item] = []
        if useItems {
            items = Items.shared.categories[category] ?? []
        }
        var caught = self.critters.count(where: { items.contains($0) || items.isEmpty && $0.appCategory == category } )
        caught += self.items.count(where: { (items.contains($0) || items.isEmpty && $0.appCategory == category) && !$0.name.contains("(fake)") })
        
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
        let added = villagers.toggle(item: villager)
        save()
        return added
    }
    
    public func toggleResident(villager: Villager) -> Bool {
        let added = residents.toggle(item: villager)
        save()
        return added
    }

    @discardableResult
    public func toggleVisitedResident(villager: Villager) -> Bool {
        let added = visitedResidents.toggle(item: villager)
        save()
        return added
    }

    public func resetVisitedResidents() {
        visitedResidents = []
        save()
    }
    
    // MARK: - Todays Tasks
    public func addCustomTask(task: DailyCustomTasks.CustomTask) {
        dailyCustomTasks.tasks.append(task)
        save()
    }
    
    public func editCustomTask(task: DailyCustomTasks.CustomTask) {
        guard let index = dailyCustomTasks.tasks.firstIndex(where: { $0.id == task.id } )
            else { return }
        dailyCustomTasks.tasks[index] = task
        save()
    }
    
    public func deleteCustomTask(at index: Int) {
        dailyCustomTasks.tasks.remove(at: index)
        save()
    }
    
    public func moveCustomTask(from: IndexSet, to: Int) {
        dailyCustomTasks.tasks.move(fromOffsets: from, toOffset: to)
        save()
    }
    
    public func updateProgress(taskId: Int) {
        dailyCustomTasks.lastUpdate = Date()
        dailyCustomTasks.tasks[taskId].curProgress += 1
        save()
    }

    public func resetProgress(taskId: Int) {
        dailyCustomTasks.lastUpdate = Date()
        dailyCustomTasks.tasks[taskId].curProgress = 0
        save()
    }
    
    public func resetTasks() {
        dailyCustomTasks.lastUpdate = Date()
        for(taskId, _) in dailyCustomTasks.tasks.enumerated() {
            dailyCustomTasks.tasks[taskId].curProgress = 0
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

    public func updateDesign(_ design: Design) {
        guard let index = designs.firstIndex(of: design) else { return }
        designs[index] = design
        save()
    }

    // MARK: - Chores

    public func addChore(_ chore: Chore) {
        chores.append(chore)
        save()
    }

    public func deleteChore(_ chore: Chore) {
        chores.removeAll { $0 == chore }
        save()
    }

    public func toggleChore(_ chore: Chore) {
        guard let index = chores.firstIndex(of: chore) else { return }
        chores[index].isFinished.toggle()
        save()
    }

    public func resetChores() {
        for index in 0..<chores.count {
            chores[index].isFinished = false
        }
        save()
    }

    public func updateChore(_ chore: Chore) {
        guard let index = chores.firstIndex(of: chore) else { return }
        chores[index] = chore
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
            guard let self = self else { return }
            do {
                let savedData = SavedData(items: self.items,
                                          variants: self.variants,
                                          villagers: self.villagers,
                                          residents: self.residents,
                                          visitedResidents: self.visitedResidents,
                                          critters: self.critters,
                                          lists: self.lists,
                                          dailyCustomTasks: self.dailyCustomTasks,
                                          designs: self.designs,
                                          chores: self.chores)
                let data = try self.encoder.encode(savedData)
                try data.write(to: self.filePath, options: .atomicWrite)
                if let url = self.sharedFilePath {
                    try data.write(to: url, options: .atomicWrite)
                }
                
                if self.isCloudEnabled {
                    DispatchQueue.main.async {
                        self.isSynched = false
                        self.saveToCloudKit()
                    }
                }
                
                WidgetCenter.shared.reloadAllTimelines()
                
            } catch let error {
                print("Error while saving collection: \(error.localizedDescription)")
            }
            self.encoder.dataEncodingStrategy = .base64
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
                self.residents = savedData.residents ?? []
                self.visitedResidents = savedData.visitedResidents ?? []
                self.critters = savedData.critters
                self.lists = savedData.lists ?? []
                self.designs = savedData.designs ?? []
                self.dailyCustomTasks = savedData.dailyCustomTasks ?? DailyCustomTasks()
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
            self.residents = []
            self.visitedResidents = []
            self.critters = []
            self.lists = []
            self.dailyCustomTasks = DailyCustomTasks()
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

public extension Dictionary where Key == String, Value == [Variant] {
    public func contains(for item: Item, variant: Variant) -> Bool {
        guard let filename = item.filename else {
            return false
        }
        return self[filename]?.contains(variant) == true
    }
}
