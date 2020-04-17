//
//  SceneDelegate.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let contentView = TabbarView()
            .environmentObject(Collection())
        if let windowScene = scene as? UIWindowScene {
            
            //TODO: Move that to SwiftUI once implemented
            UINavigationBar.appearance().largeTitleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().barTintColor = UIColor(named: "grass")
            UINavigationBar.appearance().backgroundColor = UIColor(named: "grass")
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().prefersLargeTitles = false
            
            UITableView.appearance().backgroundColor = UIColor(named: "dialogue")
            UITableViewCell.appearance().backgroundColor = UIColor(named: "dialogue")
            UITableView.appearance().tableFooterView = UIView()
            
            
            UITabBar.appearance().unselectedItemTintColor = .systemGray3
            UITabBar.appearance().barTintColor = UIColor(named: "grass")
            UITabBar.appearance().backgroundColor = UIColor(named: "grass")
            
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

