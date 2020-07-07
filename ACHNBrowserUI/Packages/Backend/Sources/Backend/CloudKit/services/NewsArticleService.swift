//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 19/06/2020.
//

import Foundation
import CloudKit
import SwiftUI

public class NewsArticleService: ObservableObject, PublicCloudService {
    
    public static let shared = NewsArticleService()
    public static let titleLocalizationKey = "ACNew.notification.title"
    public static let alertLocalizationKey = "ACNew.notification.subtitle"
    
    @Published public var articles: [NewArticle] = []
    
    init() {
        if AppUserDefaults.shared.newsNotifications {
            subscribeToCloudKit()
        }
    }
    
    public func enableNotifications() {
        subscribeToCloudKit()
    }
    
    public func disableNotifications() {
        deleteSubscriptions()
    }
    
    private func subscribeToCloudKit() {
        database.fetchAllSubscriptions { (subs, _) in
            if self.serviceSubscriptionExist(recordType: NewArticle.RecordType, subs: subs) == nil {
                self.createSubscription()
            }
        }
    }
    
    private func deleteSubscriptions() {
        database.fetchAllSubscriptions { (subs, _) in
            if let sub = self.serviceSubscriptionExist(recordType: NewArticle.RecordType, subs: subs) {
                let operation = CKModifySubscriptionsOperation(subscriptionsToSave: nil,
                                                               subscriptionIDsToDelete: [sub.subscriptionID])
                self.database.add(operation)
            }
        }
    }
    
    private func createSubscription() {
        let sub = CKQuerySubscription(recordType: NewArticle.RecordType,
                                      predicate: NSPredicate(value: true),
                                      options: .firesOnRecordCreation)
        let notif = CKSubscription.NotificationInfo()
        notif.titleLocalizationKey = Self.titleLocalizationKey
        notif.alertLocalizationKey = Self.alertLocalizationKey
        notif.soundName = "default"
        sub.notificationInfo = notif
        database.save(sub) { (_, _) in }
    }
    
    public func upvoteArticle(article: NewArticle) {
        var article = article
        article.upvotes += 1
        let record = article.toRecord(owner: nil)
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        database.add(operation)
    }
    
    public func fetchNews() {
        let query = CKQuery(recordType: NewArticle.RecordType, predicate: NSPredicate(value: true))
        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        database.perform(query, inZoneWith: nil) { (records, error) in
            if let records = records {
                DispatchQueue.main.async {
                    self.articles = records.map{ NewArticle(withRecord: $0) }
                }
            }
        }
    }
}
