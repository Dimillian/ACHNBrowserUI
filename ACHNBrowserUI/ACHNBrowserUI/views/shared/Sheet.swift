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
        case safari(URL)
        case share(content: [Any])
        case about
        case userListForm(editingList: UserList?)
        case customTasks(collection: UserCollection)
        case turnipsForm(subManager: SubscriptionManager)
        case subscription(source: SubscribeView.Source, subManager: SubscriptionManager)
        case settings(subManager: SubscriptionManager, collection: UserCollection)
        case designForm(editingDesign: Design?)
        case choreForm(chore: Chore?)
        case villager(villager: Villager, subManager: SubscriptionManager, collection: UserCollection)
        case dodoCodeForm(editing: DodoCode?)
        case iconChooser(icon: Binding<String?>)
        case dreamCodeForm(editing: DreamCode?)

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
            case .customTasks:
                return "customTasks"
            case .designForm:
                return "designForm"
            case .choreForm:
                return "choreForm"
            case .villager:
                return "villager"
            case .dodoCodeForm:
                return "dodoCodeForm"
            case .iconChooser:
                return "iconChooser"
            case .dreamCodeForm:
                return "dreamCodeForm"
            }
        }
    }
    
    let sheetType: SheetType
    
    @ViewBuilder
    var body: some View {
        switch sheetType {
        case .safari(let url):
            SafariView(url: url)
        case .share(let content):
            ActivityControllerView(activityItems: content,
                                                  applicationActivities: nil)
        case .about:
            AboutView()
        case .settings(let subManager, let collection):
            SettingsView()
                .environmentObject(subManager)
                .environmentObject(collection)
        case .turnipsForm(let subManager):
            NavigationView {
                TurnipsFormView().environmentObject(subManager)
            }.navigationViewStyle(StackNavigationViewStyle())
        case .subscription(let source, let subManager):
            SubscribeView(source: source).environmentObject(subManager)
        case .userListForm(let list):
            UserListFormView(editingList: list)
        case .customTasks(let collection):
            CustomTasksListView().environmentObject(collection)
        case .designForm(let design):
            let viewModel = DesignFormViewModel(design: design)
            DesignFormView(viewModel: viewModel)
        case .choreForm(let chore):
            let viewModel = ChoreFormViewModel(chore: chore)
            ChoreFormView(viewModel: viewModel)
        case .villager(let villager, let subManager, let collection):
            NavigationView {
                VillagerDetailView(villager: villager, isPresentedInModal: true)
                    .environmentObject(subManager)
                    .environmentObject(collection)
            }
        case .dodoCodeForm(let editing):
            DodoCodeFormView(isEditing: editing)
        case .iconChooser(let icon):
            IconChooserSheet(selectedIcon: icon)
        case .dreamCodeForm(let editing):
            DreamCodeFormView(isEditing: editing)
        }
    }
}
