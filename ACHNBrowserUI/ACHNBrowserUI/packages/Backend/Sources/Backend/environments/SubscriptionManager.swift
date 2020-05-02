//
//  SubscriptionManager.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import StoreKit

public class SubcriptionManager: NSObject, ObservableObject {
    private static let subcriptionIds: Set = ["achelperpro"]
    public static let shared = SubcriptionManager()
    
    public enum SubscriptionStatus {
        case subscribed, notSubscribed
    }
    
    @Published public var subscription: SKProduct?
    @Published public var inPaymentProgress = false
    @Published public var paymentStatus: SKPaymentTransactionState?
    @Published public var subscriptionStatus: SubscriptionStatus = AppUserDefaults.isSubscribed ? .subscribed : .notSubscribed
    
    override init() {
        super.init()
        
        loadProducts()
    }
    
    public func puschase(product: SKProduct) {
        guard !inPaymentProgress else { return }
        inPaymentProgress = true
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(payment)
    }
    
    public func restorePurchase() {
        inPaymentProgress = true
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    private func loadProducts() {
        let request = SKProductsRequest(productIdentifiers: Self.subcriptionIds)
        request.delegate = self
        request.start()
        
    }
}

extension SubcriptionManager: SKProductsRequestDelegate {
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.subscription = response.products.first
    }
    
    public func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Product request failed: \(error.localizedDescription)")
    }
}

extension SubcriptionManager: SKPaymentTransactionObserver {
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .failed:
                queue.finishTransaction(transaction)
                subscriptionStatus = .notSubscribed
                inPaymentProgress = false
                print("Payment failed for transaction: \(transaction)")
            case .purchased, .restored:
                queue.finishTransaction(transaction)
                subscriptionStatus = .subscribed
                inPaymentProgress = false
                AppUserDefaults.isSubscribed = true
            case .deferred, .purchasing:
                subscriptionStatus = .notSubscribed
                inPaymentProgress = true
            @unknown default:
                subscriptionStatus = .notSubscribed
                inPaymentProgress = false
            }
        }
    }
}
