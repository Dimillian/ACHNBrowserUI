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

struct TurnipExchangeService {
    struct IslandContainer: Decodable {
        let success: Bool
        let message: String
        let islands: [Island]
    }
    
    class WebKitCoordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        var callback: ((IslandContainer?) -> Void)?
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.body.children[0].innerHTML") { [weak self] html, err in
                if let text = html as? String, let data = text.data(using: .utf8) {
                    self?.callback?(try? JSONDecoder().decode(IslandContainer.self, from: data))
                }
            }
        }
    }
    
    private static let baseURL = URL(string: "https://api.turnip.exchange")!
    private static let session = URLSession.shared
    
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private static let webview = WKWebView(frame: .zero)
    private static let coordinator = WebKitCoordinator()
    
    /// Get a list of all the islands
    static func fetchIslands() -> AnyPublisher<[Island], Never> {
        Future { resolve in
            webview.uiDelegate = coordinator
            webview.navigationDelegate = coordinator
            coordinator.callback = { container in
                resolve(.success(container?.islands ?? []))
            }
            
            webview.load(URLRequest(url: baseURL.appendingPathComponent("islands")))
        }
        .delay(for: .seconds(1), scheduler: RunLoop.main)
        .eraseToAnyPublisher()
    }
}
