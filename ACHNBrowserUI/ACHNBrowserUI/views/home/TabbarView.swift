//
//  TabbarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TabbarView: View {
    @EnvironmentObject private var uiState: UIState

    var body: some View {
        UIKitTabView(selection: $uiState.selectedTabIndex, [
            UIKitTabView.Tab(
                view: TodayView(),
                title: "Dashboard",
                image: "icon-bells"
            ),
            UIKitTabView.Tab(
                view: CategoriesView(categories: Category.items()),
                title: "Catalog",
                image: "icon-leaf"
            ),
            UIKitTabView.Tab(
                view: TurnipsView(),
                title: "Turnips",
                image: "icon-turnip"
            ),
            UIKitTabView.Tab(
                view: VillagersListView()
                    .environmentObject(UserCollection.shared),
                title: "Villagers",
                image: "icon-villager"
            ),
            UIKitTabView.Tab(
                view: CollectionListView(),
                title: "Collection",
                image: "icon-cardboard"
            ),
        ])
    }
}

/**
 An iOS style TabView that doesn't reset it's childrens navigation stacks when tabs are switched.

 Temporary until SwiftUI tabbar works the same as UIKit

 Creates a SwiftUI -> UIKit -> SwiftUI sandwhich

 From: https://gist.github.com/Amzd/2eb5b941865e8c5cccf149e6e07c8810
 */
fileprivate struct UIKitTabView: View {
    var viewControllers: [UIHostingController<AnyView>]
    var selectedIndex: Binding<Int>

    init(selection: Binding<Int>, _ views: [Tab]) {
        self.selectedIndex = selection
        self.viewControllers = views.map {
            let host = UIHostingController(rootView: $0.view)
            host.tabBarItem = $0.barItem
            return host
        }
    }

    var body: some View {
        TabBarController(controllers: viewControllers, selectedIndex: selectedIndex)
            .edgesIgnoringSafeArea(.all)
    }

    struct Tab {
        var view: AnyView
        var barItem: UITabBarItem

        init<V: View>(view: V, barItem: UITabBarItem) {
            self.view = AnyView(view)
            self.barItem = barItem
        }

        // convenience
        init<V: View>(view: V, title: String?, image: String, selectedImage: String? = nil) {
            let barItem = UITabBarItem(title: title, image: nil, selectedImage: nil)
            barItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
            barItem.selectedImage = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
            barItem.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
            self.init(view: view, barItem: barItem)
        }
    }
}

fileprivate struct TabBarController: UIViewControllerRepresentable {
    var controllers: [UIViewController]
    @Binding var selectedIndex: Int

    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = controllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = 0
        return tabBarController
    }

    func updateUIViewController(_ tabBarController: UITabBarController, context: Context) {
        tabBarController.selectedIndex = selectedIndex
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: TabBarController

        init(_ tabBarController: TabBarController) {
            self.parent = tabBarController
        }

        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            if parent.selectedIndex == tabBarController.selectedIndex {
                popToRootViewController(viewController: viewController)
            }

            parent.selectedIndex = tabBarController.selectedIndex
        }

        fileprivate func popToRootViewController(viewController: UIViewController) {
            guard let navCon = getNavigationController(viewController: viewController)  else {
                return
            }

            navCon.popToRootViewController(animated: true)
        }

        fileprivate func getNavigationController(viewController: UIViewController) -> UINavigationController? {
            if viewController is UINavigationController {
                return viewController as? UINavigationController
            }

            for childViewController in viewController.children {
                if childViewController is UINavigationController {
                    return childViewController as? UINavigationController
                }

                if childViewController.children.count > 0 {
                    if let nav = getNavigationController(viewController: childViewController) {
                        return nav
                    }
                }
            }

            return nil
        }
    }
}
