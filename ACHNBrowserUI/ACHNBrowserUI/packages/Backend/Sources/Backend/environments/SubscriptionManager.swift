//
//  SubscriptionManager.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Purchases

public class SubscriptionManager: ObservableObject {
    public static let shared = SubscriptionManager()
    
    public enum SubscriptionStatus {
        case subscribed, notSubscribed
    }
    
    @Published public var subscription: Purchases.Package?
    @Published public var lifetime: Purchases.Package?
    @Published public var inPaymentProgress = false
    @Published public var paymentStatus: SKPaymentTransactionState?
    @Published public var subscriptionStatus: SubscriptionStatus = AppUserDefaults.shared.isSubscribed ? .subscribed : .notSubscribed
    
    init() {        
        Purchases.configure(withAPIKey: "glVAIPplNhAuvgOlCcUcrEaaCQwLRzQs")
        Purchases.shared.offerings { (offerings, error) in
            self.subscription = offerings?.current?.monthly
            self.lifetime = offerings?.current?.lifetime
        }
        refreshSubscription()
    }
    
    public func purchase(source: String, product: Purchases.Package) {
        guard !inPaymentProgress else { return }
        inPaymentProgress = true
        Purchases.shared.setAttributes(["source": source])
        Purchases.shared.purchasePackage(product) { (_, info, _, _) in
            self.processInfo(info: info)
        }
    }
    
    
    public func refreshSubscription() {
        Purchases.shared.purchaserInfo { (info, _) in
            self.processInfo(info: info)
        }
    }
    
    public func restorePurchase() {
        Purchases.shared.restoreTransactions { (info, _) in
            self.processInfo(info: info)
        }
    }
    
    private func processInfo(info: Purchases.PurchaserInfo?) {
        if info?.entitlements.all["AC+"]?.isActive == true {
            subscriptionStatus = .subscribed
            AppUserDefaults.shared.isSubscribed = true
        } else {
            AppUserDefaults.shared.isSubscribed = false
            subscriptionStatus = .notSubscribed
        }
        inPaymentProgress = false
    }
}
