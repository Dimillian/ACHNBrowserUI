//
//  VillagerDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend
import UI

struct VillagerDetailView: View {
    @StateObject var viewModel: VillagerDetailViewModel
    @Environment(\.presentationMode) var presentation
    
    @State private var backgroundColor = Color.acSecondaryBackground
    @State private var textColor = Color.acText
    @State private var secondaryTextColor = Color.acSecondaryText
    @State private var sheet: Sheet.SheetType?
    @State private var isLoadingItem = true
    @State private var expandedHouseItems = false
    @State private var expandedLikeItems = false

    let isPresentedInModal: Bool
    var villager: Villager {
        viewModel.villager
    }
    
    init(villager: Villager, isPresentedInModal: Bool = false) {
        self._viewModel = StateObject(wrappedValue: VillagerDetailViewModel(villager: villager))
        self.isPresentedInModal = isPresentedInModal
    }
    
    private var shareButton: some View {
        Button(action: {
            let image = NavigationView {
                self.makeBody(items: false)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(width: 350, height: 750).asImage()
            self.sheet = .share(content: [ItemDetailSource(name: self.villager.localizedName, image: image)])
        }) {
            Image(systemName: "square.and.arrow.up").imageScale(.large)
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
        
    private var navButtons: some View {
        HStack(spacing: 8) {
            ResidentButton(villager: villager)
                .environmentObject(UserCollection.shared)
                .safeHoverEffectBarItem(position: .trailing)
            LikeButtonView(villager: villager)
                .safeHoverEffectBarItem(position: .trailing)
            shareButton.padding(.top, -6)
        }
    }
    
    private func makeInfoCell(title: LocalizedStringKey, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(textColor)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Text(LocalizedStringKey(value))
                .foregroundColor(secondaryTextColor)
                .font(.subheadline)
        }.listRowBackground(Rectangle().fill(backgroundColor))
    }

    private var makeCloseButton: some View {
        if isPresentedInModal {
            return Button(action: { self.presentation.wrappedValue.dismiss() }) {
                Image(systemName: "xmark.circle.fill")
                    .style(appStyle: .barButton)
                    .foregroundColor(.acText)
            }
            .buttonStyle(BorderedBarButtonStyle())
            .accentColor(Color.acText.opacity(0.2))
            .safeHoverEffectBarItem(position: .leading)
            .eraseToAnyView()
        } else {
            return EmptyView().eraseToAnyView()
        }
    }
    
    private func makeBody(items: Bool) -> some View {
        List {
            HStack {
                Spacer()
                ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                    ACNHApiService.Endpoint.villagerImage(id: villager.id).path(),
                          size: 150).cornerRadius(40)
                Spacer()
            }
            .listRowBackground(Rectangle().fill(backgroundColor))
            .padding()
            makeInfoCell(title: "Personality", value: villager.personality).padding()
            makeInfoCell(title: "Birthday", value: villager.formattedBirthday ?? "Unknown").padding()
            if let likes = viewModel.likes {
                makeInfoCell(title: "Like",
                             value: ListFormatter.localizedString(byJoining: likes.map{ $0.capitalized }))
                    .padding()
            }
            makeInfoCell(title: "Species", value: villager.species).padding()
            makeInfoCell(title: "Gender", value: villager.gender).padding()
            makeInfoCell(title: "Catch phrase", value: villager.localizedCatchPhrase.capitalized).padding()
            
            if items {
                Section(header: SectionHeaderView(text: "Villager items", icon: "list.bullet")) {
                    if viewModel.villagerItems?.isEmpty == false {
                        ForEach(expandedHouseItems ? viewModel.villagerItems! : viewModel.villagerItems!.prefix(3).map{ $0 }) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(displayMode: .large, item: item)
                            }
                            .listRowBackground(Color.acSecondaryBackground)
                        }
                        if !expandedHouseItems {
                            Button(action: {
                                self.expandedHouseItems = true
                            }) {
                                Text("See more")
                                    .fontWeight(.bold)
                                    .foregroundColor(.acHeaderBackground)
                            }
                            .listRowBackground(Color.acSecondaryBackground)
                        }
                    } else {
                        RowLoadingView()
                    }
                }
                
                Section(header: SectionHeaderView(text: "Gifts ideas", icon: "gift")) {
                    if viewModel.preferredItems?.isEmpty == false {
                        ForEach(expandedLikeItems ? viewModel.preferredItems! : viewModel.preferredItems!.prefix(3).map{ $0 }) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(displayMode: .large, item: item)
                            }
                            .listRowBackground(Color.acSecondaryBackground)
                        }
                        if !expandedLikeItems {
                            Button(action: {
                                self.expandedLikeItems = true
                            }) {
                                Text("See more")
                                    .fontWeight(.bold)
                                    .foregroundColor(.acHeaderBackground)
                            }
                            .listRowBackground(Color.acSecondaryBackground)
                        }
                    } else {
                        RowLoadingView()
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle(Text(villager.localizedName), displayMode: .automatic)
        .onAppear {
            viewModel.fetchItems()
            let url = ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: self.villager.id).path()
            ImageService.getImageColors(key: url) { colors in
                if let colors = colors {
                    withAnimation(.easeInOut) {
                        self.backgroundColor = Color(colors.background)
                        self.textColor = Color(colors.primary)
                        self.secondaryTextColor = Color(colors.detail)
                    }
                }
            }
        }
    }
    
    var body: some View {
        makeBody(items: true)
            .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
            .navigationBarItems(leading: makeCloseButton, trailing: navButtons)
            .onAppear(perform: viewModel.fetchItems)
    }
}

struct VillagerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        VillagerDetailView(villager: static_villager)
    }
}
