//
//  TurnipExchangeService.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import WebKit

class TurnipExchangeService: NSObject, WKScriptMessageHandler {
    static let shared = TurnipExchangeService()
    
    struct IslandContainer: Decodable {
        let success: Bool
        let message: String
        let islands: [Island]
    }
    
    struct QueueContainer: Decodable {
        let success: Bool
        let onIsland: Int
        let visitors: [Visitor]
        let total: Int
        let visitorCount: Int
    }
    
    struct Visitor: Decodable, Identifiable {
        let name: String
        let addedTimestamp: String
        let place: Int
        let time: Int
        
        var id: String {
            name
        }
    }
    
    private let config: WKWebViewConfiguration
    private let webview: WKWebView
    private var islandCallback: (([Island]) -> Void)?
    private var queueCallback: ((QueueContainer) -> Void)?

    override init() {
        self.config = WKWebViewConfiguration()
        self.webview = WKWebView(frame: .zero, configuration: self.config)
        super.init()
        
        self.config.userContentController.add(self, name: "island")
        self.config.userContentController.add(self, name: "queue")
    }
    
    /// Get a list of all the islands
    func fetchIslands() -> AnyPublisher<[Island], Never> {
        Future { [weak self] resolve in
            self?.islandCallback = {
                resolve(.success($0))
            }
            
            self?.config.userContentController.addUserScript(
                WKUserScript(
                    source: "fetch('https://api.turnip.exchange/islands/', { method: 'POST'} ).then(r => r.json()).then((r) => {window.webkit.messageHandlers.island.postMessage(r)})",
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: true
                )
            )
            
            self?.webview.load(URLRequest(url: URL(string: "https://turnip.exchange/islands")!))
        }
        .eraseToAnyPublisher()
    }
    
    func fetchQueue(turnipCode: String) -> AnyPublisher<QueueContainer, Never> {
        Future { [weak self] resolve in
            self?.queueCallback = {
                resolve(.success($0))
            }
            
            self?.config.userContentController.addUserScript(
                WKUserScript(
                    source: "fetch('https://api.turnip.exchange/island/queue/\(turnipCode)', { method: 'GET'} ).then(r => r.json()).then((r) => {window.webkit.messageHandlers.queue.postMessage(r)})",
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: true
                )
            )
            
            self?.webview.load(URLRequest(url: URL(string: "https://turnip.exchange/islands")!))
        }
        .eraseToAnyPublisher()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "island" {
            do {
                let encoded = try JSONSerialization.data(withJSONObject: message.body, options: [])
                let decoded = try JSONDecoder().decode(IslandContainer.self, from: encoded)
                
                islandCallback?(decoded.islands)
            } catch {
                print(error)
            }
        }
        if message.name == "queue" {
            do {
                let encoded = try JSONSerialization.data(withJSONObject: message.body, options: [])
                let decoded = try JSONDecoder().decode(QueueContainer.self, from: encoded)
                
                queueCallback?(decoded)
            } catch {
                print(error)
            }
        }
    }
}
