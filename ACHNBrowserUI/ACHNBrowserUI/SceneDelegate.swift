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

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = TabbarView()
            .environmentObject(UserCollection.shared)
            .environmentObject(Items.shared)
            .environmentObject(UIState())
            .environmentObject(SubscriptionManager.shared)
        
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
    }
}

