//
//  TabbarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import CoreData

struct DemoCell: View {
    var item: ItemEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            ItemImage(path: item.image?.absoluteString, size: 25)
            Text("\(item.id)")
            Group {
                item.name.map {
                    Text($0)
                }
                item.source.map {
                    Text($0)
                }
                item.detail.map {
                    Text($0)
                }
                item.tag.map {
                    Text($0)
                }
            }
            item.recipe.map { (recipe: RecipeEntity) in
                VStack(alignment: .leading) {
                    Text("Recipe: \(recipe.name ?? "No name")")
                    Text("Recipe Mat: \(recipe.materials?.count ?? 0)")
                }
            }
            Text("\(item.variants?.count ?? 0) variants")
            Text(item.colors.description)
            Text("\(item.buy)")
            Text("\(item.sell)")
        }
    }
}

struct FetchRequests {
    static func items(category: Category? = nil) -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        
        if let category = category {
            request.predicate = NSPredicate(format: "category = %@", category.rawValue)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
    
    static func items(category: [Category]) -> NSFetchRequest<ItemEntity> {
        let request: NSFetchRequest<ItemEntity> = ItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "category IN %@", category.map { $0.rawValue })
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
}

struct DemoItemsView: View {
    @FetchRequest(fetchRequest: FetchRequests.items()) var items

    var body: some View {
        List {
            ForEach(items, id: \.self) { item in
                DemoCell(item: item)
            }
        }
    }
}

struct Demo: View {
    
    func makeCell(_ category: Category) -> some View {
        NavigationLink(destination: DemoItemsView(items: .init(fetchRequest: FetchRequests.items(category: category)))) {
            Text(category.rawValue.localizedCapitalized)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(Category.allCases, id: \.self, content: makeCell)
            }
            .navigationBarTitle("Demo", displayMode: .inline)
        }
    }
}

struct TabbarView: View {
    enum Tab: Int {
        case demo, dashboard, items, villagers, collection, turnips
    }
    
    @State var selectedTab = Tab.demo
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(image)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                Demo().tabItem{
                    self.tabbarItem(text: "Demo", image: "icon-bells")
                }.tag(Tab.demo)
                DashboardView().tabItem{
                    self.tabbarItem(text: "Dashboard", image: "icon-bells")
                }.tag(Tab.dashboard)
                CategoriesView(categories: Categories.items()).tabItem{
                    self.tabbarItem(text: "Catalog", image: "icon-leaf")
                }.tag(Tab.items)
                TurnipsView().tabItem {
                    tabbarItem(text: "Turnips", image: "icon-turnip")
                }.tag(Tab.turnips)
                VillagersListView().tabItem{
                    self.tabbarItem(text: "Villagers", image: "icon-villager")
                }.tag(Tab.villagers)
                CollectionListView().tabItem{
                    self.tabbarItem(text: "My Stuff", image: "icon-cardboard")
                }.tag(Tab.collection)
            }
        }.accentColor(.white)
    }
}
