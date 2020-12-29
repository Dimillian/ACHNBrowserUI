//
//  ItemDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemDetailView: View {
    // MARK: - Vars
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @EnvironmentObject private var musicPlayer: MusicPlayerManager

    @StateObject private var itemViewModel: ItemDetailViewModel
    
    @State private var displayedVariant: Variant?
    @State private var selectedSheet: Sheet.SheetType?

    init(item: Item) {
        self._itemViewModel = StateObject(wrappedValue: ItemDetailViewModel(item: item))
    }

    private func makeShareContent() -> [Any] {
        let image =
            NavigationView {
                List {
                    ItemDetailInfoView(item: itemViewModel.item,
                                       recipe: itemViewModel.recipe,
                                       displayedVariant: $displayedVariant)
                }
                .listStyle(InsetGroupedListStyle())
                .navigationBarTitle(Text(itemViewModel.item.localizedName.capitalized),
                                    displayMode: .large)
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .frame(width: 350, height: 450)
            .asImage()
        
        return [ItemDetailSource(name: itemViewModel.item.localizedName.capitalized, image: image)]
    }
    
    // MARK: - Boby
    var body: some View {
        List {
            ItemDetailInfoView(item: itemViewModel.item,
                               recipe: itemViewModel.recipe,
                               displayedVariant: $displayedVariant)
                .listRowBackground(Color.acSecondaryBackground)
            Group {
                if itemViewModel.item.variations != nil {
                    variantsSection
                }
                
                if itemViewModel.item.appCategory == .music {
                    musicPlayerSection
                }
                
                if !itemViewModel.item.metas.isEmpty {
                    keywordsSection
                }
            }.listRowBackground(Color.acSecondaryBackground)
            
            Group {
                if !itemViewModel.setItems.isEmpty {
                    ItemsCrosslineSectionView(title: "Set items",
                                              items: itemViewModel.setItems,
                                              icon: "paperclip.circle.fill",
                                              currentItem: $itemViewModel.item,
                                              selectedVariant: $displayedVariant)
                }
                if !itemViewModel.similarItems.isEmpty {
                    ItemsCrosslineSectionView(title: "Simillar items",
                                              items: itemViewModel.similarItems,
                                              icon: "eyedropper.full",
                                              currentItem: $itemViewModel.item,
                                              selectedVariant: $displayedVariant)
                }
                if !itemViewModel.thematicItems.isEmpty {
                    ItemsCrosslineSectionView(title: "Thematics",
                                              items: itemViewModel.thematicItems,
                                              icon: "tag.fill",
                                              currentItem: $itemViewModel.item,
                                              selectedVariant: $displayedVariant)
                }
                if itemViewModel.item.materials != nil || itemViewModel.recipe?.materials != nil {
                    materialsSection
                }
                if itemViewModel.item.isCritter {
                    ItemDetailSeasonSectionView(item: itemViewModel.item)
                }
            }.listRowBackground(Color.acSecondaryBackground)
            
            listsSection
        }
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: {
            self.displayedVariant = nil
            self.itemViewModel.setupItems()
        })
        .navigationBarItems(trailing: navButtons)
        .navigationBarTitle(Text(itemViewModel.item.localizedName.capitalized), displayMode: .large)
        .sheet(item: $selectedSheet) {
            Sheet(sheetType: $0)
        }
    }
}

// MARK: - Views
extension ItemDetailView {
    private var shareButton: some View {
        Button(action: {
            self.selectedSheet = .share(content: self.makeShareContent())
        }) {
            Image(systemName: "square.and.arrow.up").imageScale(.large)
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var navButtons: some View {
        HStack {
            LikeButtonView(item: itemViewModel.item,
                           variant: displayedVariant).imageScale(.large)
                .safeHoverEffectBarItem(position: .trailing)
            shareButton
        }
    }
    
    private var keywordsSection: some View {
        Section(header: SectionHeaderView(text: "Keywords", icon: "link")) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(itemViewModel.item.metas, id: \.self) { meta in
                        NavigationLink(destination: LazyView(ItemsView(category: .other, keyword: meta))) {
                                                                    ItemStyleBadgeView(title: meta)
                        }
                    }
                }.padding()
            }.listRowInsets(EdgeInsets())
        }
    }
    
    private var variantsSection: some View {
        Section(header: SectionHeaderView(text: "Variants", icon: "paintbrush.fill")) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    itemViewModel.item.variations.map { variants in
                        ForEach(variants, content: makeVariantRow(variant:))
                    }
                }.padding()
            }
            .listRowInsets(EdgeInsets())
        }
    }
    
    private func makeVariantRow(variant: Variant) -> some View {
        ZStack(alignment: .topLeading) {
            ItemImage(path: variant.content.image,
                      size: 75)
                .onTapGesture {
                    withAnimation {
                        if self.itemViewModel.item.variations?.firstIndex(of: variant) == 0 {
                            self.displayedVariant = nil
                        } else {
                            self.displayedVariant = variant
                        }
                        FeedbackGenerator.shared.triggerSelection()
                    }
            }
            LikeButtonView(item: itemViewModel.item, variant: variant)
        }
    }
    
    private var materialsSection: some View {
        Section(header: SectionHeaderView(text: "Materials", icon: "leaf.arrow.circlepath")) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    (itemViewModel.item.materials ?? itemViewModel.recipe?.materials).map { materials in
                        ForEach(materials) { material in
                            VStack {
                                Image(material.iconName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                Text(material.itemName)
                                    .font(.callout)
                                    .foregroundColor(.acText)
                                Text("\(material.count)")
                                    .font(.footnote)
                                    .foregroundColor(.acHeaderBackground)
                                
                            }
                        }
                    }
                }.padding()
            }
            .listRowInsets(EdgeInsets())
        }
    }
    
    private var listsSection: some View {
        Section(header: SectionHeaderView(text: "Your items lists", icon: "list.bullet")) {
            if subscriptionManager.subscriptionStatus == .subscribed || collection.lists.isEmpty {
                Button(action: {
                    self.selectedSheet = .userListForm(editingList: nil)
                }) {
                    Text("Create a new list").foregroundColor(.acHeaderBackground)
                }.listRowBackground(Color.acSecondaryBackground)
            }
            ForEach(collection.lists) { list in
                HStack {
                    Image(systemName: list.items.contains(self.itemViewModel.item) ? "checkmark.seal.fill": "checkmark.seal")
                        .foregroundColor(list.items.contains(self.itemViewModel.item) ? Color.acTabBarBackground : Color.acText)
                        .scaleEffect(list.items.contains(self.itemViewModel.item) ? 1.2 : 0.9)
                        .animation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.5))
                    UserListRow(list: list)
                }.onTapGesture {
                    if let index = list.items.firstIndex(of: self.itemViewModel.item) {
                        self.collection.deleteItem(for: list.id, at: index)
                    } else {
                        self.collection.addItems(for: list.id, items: [self.itemViewModel.item])
                    }
                }
                .listRowBackground(Color.acSecondaryBackground)
            }
            if subscriptionManager.subscriptionStatus != .subscribed && collection.lists.count >= 1 {
                UserListSubscribeCallView(sheet: $selectedSheet)
                    .listRowBackground(Color.acSecondaryBackground)
            }
        }
    }
    
    private var musicPlayerSection: some View {
        Section(header: SectionHeaderView(text: "Music player", icon: "music.note")) {
            HStack {
                Spacer()
                Button(action: {
                    if self.musicPlayer.isPlaying {
                        self.musicPlayer.isPlaying = false
                        return
                    }
                    if let song = self.musicPlayer.matchSongFrom(item: self.itemViewModel.item) {
                        self.musicPlayer.currentSong = song
                        self.musicPlayer.isPlaying = true
                    }
                }) {
                    Image(systemName: musicPlayer.isPlaying ? "pause.fill" : "play.fill")
                        .imageScale(.large)
                        .foregroundColor(.acText)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
        }
    }
}

// MARK: - Preview
struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                ItemDetailView(item: static_item)
                    .environmentObject(UserCollection.shared)
                    .environmentObject(MusicPlayerManager.shared)
                    .environmentObject(SubscriptionManager.shared)
            }
            
            NavigationView {
                ItemDetailView(item: static_item)
                    .environmentObject(UserCollection.shared)
                    .environmentObject(MusicPlayerManager.shared)
                    .environmentObject(SubscriptionManager.shared)
            }
            .environment(\.colorScheme, .dark)
        }
    }
}
