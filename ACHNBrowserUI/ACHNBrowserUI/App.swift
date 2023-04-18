//
//  App.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 25/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import UserNotifications
import CoreSpotlight
import CloudKit
import Backend
import UI
import Pendo

class AppDelegateAdaptor: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        let appKey = "APP_KEY"
        //PendoManager.shared().setDebugMode(true)
        PendoManager.shared().setup(appKey, with: nil)
        PendoManager.shared().startSession("v61",accountId:"a5", visitorData: ["visitor5":"visitor5"], accountData: ["account5":"account5"])
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let infos = CKNotification.init(fromRemoteNotificationDictionary: userInfo) {
            if infos.titleLocalizationKey == DodoCodeService.titleLocalizationKey {
                UIState.shared.route = .dodo
            } else if infos.titleLocalizationKey == NewsArticleService.titleLocalizationKey {
                UIState.shared.route = .news
            } else {
                UserCollection.shared.reloadFromCloudKit()
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme?.range(of: "pendo") != nil {
            PendoManager.shared().initWith(url)
            return true
        }
        return true
    }
}

@main
struct ACHelperApp: App {
    @UIApplicationDelegateAdaptor(AppDelegateAdaptor.self) private var appDelegate
    @StateObject private var uiState = UIState.shared
    
    @SceneBuilder
    var body: some Scene {
        #if targetEnvironment(macCatalyst)
        WindowGroup {
            contentView
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        #else
        WindowGroup {
            contentView
                .enableSwiftUI()
                .onOpenURL(perform: handleURLPendo)
        }
        #endif
        
        #if targetEnvironment(macCatalyst)
        Settings {
            SettingsView()
        }
        #endif
    }
    
    func handleURLPendo(_ url: URL) {
        print("open url called")
        _ = appDelegate.application(UIApplication.shared, open: url, options: [:])

    }
    
    private var contentView: some View {
        TabbarView()
            .environmentObject(UserCollection.shared)
            .environmentObject(Items.shared)
            .environmentObject(uiState)
            .environmentObject(SubscriptionManager.shared)
            .environmentObject(TurnipPredictionsService.shared)
            .environmentObject(MusicPlayerManager.shared)
            .environmentObject(AppUserDefaults.shared)
            .environmentObject(DodoCodeService.shared)
            .environmentObject(DreamCodeService.shared)
            .environmentObject(CommentService.shared)
            .environmentObject(NewsArticleService.shared)
            .onAppear(perform: setupAppearance)
            .onContinueUserActivity(CSSearchableItemActionType, perform: handleSpotlight(_:))
            .onOpenURL(perform: handleURL(url:))
            .sheet(item: $uiState.route,
                   onDismiss: {
                uiState.route = nil
            }, content: {
                $0.makeSheetView()
            })
    }
    
    private func handleSpotlight(_ userActivity: NSUserActivity) {
        if let infos = userActivity.userInfo,
           let id = infos[CSSearchableItemActivityIdentifier] as? String,
           let name = id.components(separatedBy: "#").last,
           let item = Items.shared.categories[Backend.Category(itemCategory: id.components(separatedBy: "#").first!)]?.first(where: { $0.name == name }) {
            uiState.route = UIState.Route.item(item: item)
        }
    }
    
    private func handleURL(url: URL) {
        if url.absoluteString.hasPrefix(UIState.Route.prefix),
           url.pathComponents.count == 2 {
            //TODO: Handle villager URL
        }
    }
    
    private func setupAppearance() {
        //TODO: Move that to SwiftUI once implemented
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).withSymbolicTraits(.traitBold)?.withDesign(UIFontDescriptor.SystemDesign.rounded)
        let descriptor2 = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withSymbolicTraits(.traitBold)?.withDesign(UIFontDescriptor.SystemDesign.rounded)
        
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.font:UIFont.init(descriptor: descriptor2!, size: 34),
            NSAttributedString.Key.foregroundColor: UIColor(named: "ACText",
                                                            in: UIBundle,
                                                            compatibleWith: nil)!
        ]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.font:UIFont.init(descriptor: descriptor!, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor(named: "ACText",
                                                            in: UIBundle,
                                                            compatibleWith: nil)!
        ]
        
        UINavigationBar.appearance().barTintColor = UIColor(named: "ACSecondaryBackground",
                                                            in: UIBundle,
                                                            compatibleWith: nil)
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().tintColor = UIColor(named: "ACText",
                                                         in: UIBundle,
                                                         compatibleWith: nil)
        
        UITableView.appearance().backgroundColor = UIColor(named: "ACBackground",
                                                           in: UIBundle,
                                                           compatibleWith: nil)
        UITableView.appearance().tableFooterView = UIView()
    }
}
