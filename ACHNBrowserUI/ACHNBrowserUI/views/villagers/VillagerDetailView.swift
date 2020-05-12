//
//  VillagerDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct VillagerDetailView: View {
    @ObservedObject var viewModel: VillagerDetailViewModel
    @EnvironmentObject private var collection: UserCollection
    @State private var backgroundColor = Color.acSecondaryBackground
    @State private var textColor = Color.acText
    @State private var secondaryTextColor = Color.acSecondaryText
    @State private var sheet: Sheet.SheetType?
    @State private var isLoadingItem = true
    
    var villager: Villager {
        viewModel.villager
    }
    
    init(villager: Villager) {
        self.viewModel = VillagerDetailViewModel(villager: villager)
    }
    
    private var shareButton: some View {
        Button(action: {
            let image = NavigationView {
                self.makeBody().environmentObject(self.collection)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(width: 350, height: 650).asImage()
            self.sheet = .share(content: [ItemDetailSource(name: self.villager.localizedName, image: image)])
        }) {
            Image(systemName: "square.and.arrow.up").imageScale(.large)
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var navButtons: some View {
        HStack(spacing: 8) {
            LikeButtonView(villager: villager)
                .environmentObject(collection)
                .safeHoverEffectBarItem(position: .trailing)
            shareButton.padding(.top, -6)
        }
    }
    
    private func makeInfoCell(title: String, value: String) -> some View {
        HStack {
            Text(LocalizedStringKey(title))
                .foregroundColor(textColor)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .foregroundColor(secondaryTextColor)
                .font(.subheadline)
        }.listRowBackground(Rectangle().fill(backgroundColor))
    }
    
    private func makeBody() -> some View {
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
            makeInfoCell(title: "Birthday", value: villager.formattedBirthday ?? NSLocalizedString("Unknown", comment: "")).padding()
            makeInfoCell(title: "Species", value: villager.species).padding()
            makeInfoCell(title: "Gender", value: villager.gender).padding()
            makeInfoCell(title: "Catch phrase", value: villager.catchPhrase ?? "").padding()
            
            Section(header: SectionHeaderView(text: "Villager items", icon: "list.bullet")) {
                if viewModel.villagerItems?.isEmpty == false {
                    ForEach(viewModel.villagerItems!) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            ItemRowView(displayMode: .large, item: item)
                        }
                    }
                } else {
                    RowLoadingView(isLoading: .constant(true))
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text(villager.localizedName), displayMode: .automatic)
        .onAppear {
            self.viewModel.fetchItems()
            
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
        makeBody()
            .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
            .navigationBarItems(trailing: navButtons)
    }
}
