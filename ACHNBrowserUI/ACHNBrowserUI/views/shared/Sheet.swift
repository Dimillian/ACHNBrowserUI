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
        case about, userListForm
        case turnipsForm(subManager: SubcriptionManager)
        case subscription(subManager: SubcriptionManager)
        case settings(subManager: SubcriptionManager)
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            case .share:
                return "share"
            case .about:
                return "about"
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
        case .userListForm:
            return AnyView(UserListFormView(editingList: nil))
        }
    }
    
    var body: some View {
        make()
    }
}
