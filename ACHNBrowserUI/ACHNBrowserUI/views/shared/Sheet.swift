//
//  Sheet.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct Sheet: View {
    enum SheetType: Identifiable {
        case safari(URL), share(content: [Any])
        case about, rearrange
        case userListForm(editingList: UserList?)
        case turnipsForm(subManager: SubscriptionManager)
        case subscription(subManager: SubscriptionManager)
        case settings(subManager: SubscriptionManager)
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            case .share:
                return "share"
            case .about:
                return "about"
            case .rearrange:
                return "rearrange"
            case .settings:
                return "about"
            case .turnipsForm:
                return "turnipsForm"
            case .subscription:
                return "sub"
            case .userListForm:
                return "userListForm"
            }
        }
    }
    
    let sheetType: SheetType
    
    private func make() -> some View {
        switch sheetType {
        case .safari(let url):
            return AnyView(SafariView(url: url))
        case .share(let content):
            return AnyView(ActivityControllerView(activityItems: content,
                                                  applicationActivities: nil))
        case .about:
            return AnyView(AboutView())
        case .settings(let subManager):
            return AnyView(SettingsView().environmentObject(subManager))
        case .turnipsForm(let subManager):
            return AnyView(NavigationView {
                TurnipsFormView().environmentObject(subManager)
            }.navigationViewStyle(StackNavigationViewStyle()))
        case .subscription(let subManager):
            return AnyView(SubscribeView().environmentObject(subManager))
        case .userListForm(let list):
            return AnyView(UserListFormView(editingList: list))
        case .rearrange:
            return AnyView(NavigationView {
                TodaySectionEditView()
            }
            .navigationViewStyle(StackNavigationViewStyle()))
        }
    }
    
    var body: some View {
        make()
    }
}
