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
    struct IslandContainer: Decodable {
        let success: Bool
        let message: String
        let islands: [Island]
    }
    
    private let config: WKWebViewConfiguration
    private let webview: WKWebView
    private var callback: (([Island]) -> Void)?
    
    override init() {
        self.config = WKWebViewConfiguration()
        self.webview = WKWebView(frame: .zero, configuration: self.config)
        super.init()
        
        self.config.userContentController.add(self, name: "messageBox")
    }
    
    /// Get a list of all the islands
    func fetchIslands() -> AnyPublisher<[Island], Never> {
        Future { [weak self] resolve in
            self?.callback = {
                resolve(.success($0))
            }
            
            self?.config.userContentController.addUserScript(
                WKUserScript(
                    source: "fetch('https://api.turnip.exchange/islands/', { method: 'POST'} ).then(r => r.json()).then((r) => {window.webkit.messageHandlers.messageBox.postMessage(r)})",
                    injectionTime: .atDocumentEnd,
                    forMainFrameOnly: true
                )
            )
            
            self?.webview.load(URLRequest(url: URL(string: "https://turnip.exchange/islands")!))
        }
        .eraseToAnyPublisher()
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        do {
            let encoded = try JSONSerialization.data(withJSONObject: message.body, options: [])
            let decoded = try JSONDecoder().decode(IslandContainer.self, from: encoded)
            
            callback?(decoded.islands)
        } catch {
            print(error)
        }
    }
}
