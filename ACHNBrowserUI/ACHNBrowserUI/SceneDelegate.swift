//
//  SceneDelegate.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftUI
import Backend
import CoreSpotlight
import StoreKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let uiState = UIState()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = TabbarView()
            .environmentObject(UserCollection.shared)
            .environmentObject(Items.shared)
            .environmentObject(uiState)
            .environmentObject(SubscriptionManager.shared)
            .environmentObject(TurnipPredictionsService.shared)
            .environmentObject(MusicPlayerManager.shared)
            .environmentObject(AppUserDefaults.shared)
            .environmentObject(DodoCodeService.shared)
            .environmentObject(CommentService.shared)
        
        if let windowScene = scene as? UIWindowScene {
            
            //TODO: Move that to SwiftUI once implemented
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).withSymbolicTraits(.traitBold)?.withDesign(UIFontDescriptor.SystemDesign.rounded)
            let descriptor2 = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withSymbolicTraits(.traitBold)?.withDesign(UIFontDescriptor.SystemDesign.rounded)
            
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedString.Key.font:UIFont.init(descriptor: descriptor2!, size: 34),
                NSAttributedString.Key.foregroundColor: UIColor(named: "ACText")!
            ]
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.font:UIFont.init(descriptor: descriptor!, size: 17),
                NSAttributedString.Key.foregroundColor: UIColor(named: "ACText")!
            ]
            
            UINavigationBar.appearance().barTintColor = UIColor(named: "ACSecondaryBackground")
            UINavigationBar.appearance().backgroundColor = UIColor(named: "ACBackground")
            UINavigationBar.appearance().tintColor = UIColor(named: "ACText")
            
            UITableView.appearance().backgroundColor = UIColor(named: "ACBackground")
            UITableViewCell.appearance().backgroundColor = UIColor(named: "ACSecondaryBackground")
            UITableView.appearance().tableFooterView = UIView()
            
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "TabLabel")
            UITabBar.appearance().barTintColor = UIColor(named: "ACTabBarTint")
            UITabBar.appearance().backgroundColor = UIColor(named: "ACTabBarTint")
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
			#if targetEnvironment(macCatalyst)
			window.windowScene?.titlebar?.titleVisibility = .hidden
			#endif
            window.makeKeyAndVisible()
        }
        
        if let activity = connectionOptions.userActivities.first {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.routeUserActivity(userActivity: activity)
            }
        }
        
        AppUserDefaults.shared.numberOfLaunch += 1
        if AppUserDefaults.shared.numberOfLaunch == 3 {
            SKStoreReviewController.requestReview()
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        routeUserActivity(userActivity: userActivity)
    }
    
    func routeUserActivity(userActivity: NSUserActivity) {
        if userActivity.activityType == CSSearchableItemActionType {
            if let infos = userActivity.userInfo,
                let id = infos[CSSearchableItemActivityIdentifier] as? String,
                let name = id.components(separatedBy: "#").last,
                let item = Items.shared.categories[Backend.Category(itemCategory: id.components(separatedBy: "#").first!)]?.first(where: { $0.name == name }) {
                self.uiState.route = UIState.Route.item(item: item)
                self.uiState.routeEnabled = true
            }
        }
    }
}

