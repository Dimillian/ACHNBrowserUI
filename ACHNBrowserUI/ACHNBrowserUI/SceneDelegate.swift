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
            .environmentObject(UserCollection())
            .environmentObject(Items.shared)
        
        if let windowScene = scene as? UIWindowScene {
            
            //TODO: Move that to SwiftUI once implemented
            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .title1).withSymbolicTraits(.traitBold)?.withDesign(UIFontDescriptor.SystemDesign.rounded)
            let descriptor2 = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withSymbolicTraits(.traitBold)?.withDesign(UIFontDescriptor.SystemDesign.rounded)
            
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedString.Key.font:UIFont.init(descriptor: descriptor2!, size: 34),
                NSAttributedString.Key.foregroundColor: UIColor(named: "text")!
            ]
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.font:UIFont.init(descriptor: descriptor!, size: 17),
                NSAttributedString.Key.foregroundColor: UIColor(named: "text")!
            ]
            
            UINavigationBar.appearance().barTintColor = UIColor(named: "dialogue")
            UINavigationBar.appearance().backgroundColor = UIColor(named: "dialogue-reverse")
            UINavigationBar.appearance().tintColor = UIColor(named: "text")
            
            UITableView.appearance().backgroundColor = UIColor(named: "dialogue-reverse")
            UITableViewCell.appearance().backgroundColor = UIColor(named: "dialogue")
            UITableView.appearance().tableFooterView = UIView()
            
            
            UITabBar.appearance().unselectedItemTintColor = UIColor(named: "TabLabel")
            UITabBar.appearance().barTintColor = UIColor(named: "grass")
            UITabBar.appearance().backgroundColor = UIColor(named: "grass")
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

