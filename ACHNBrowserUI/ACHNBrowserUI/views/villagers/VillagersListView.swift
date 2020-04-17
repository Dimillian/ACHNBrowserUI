//
//  VillagersListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct VillagersListView: View {
    @ObservedObject var viewModel = VillagersViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.villagers) { villager in
                HStack {
                    ItemImage(imageLoader: ImageLoader(path: ACNHApiService.BASE_URL.absoluteString +
                        ACNHApiService.Endpoint.villagerIcon(id: villager.id).path()),
                              size: 50)
                    Text(villager.name["name-en"] ?? "")
                }
            }
            .onAppear(perform: viewModel.fetch)
            .background(Color.dialogue)
            .navigationBarTitle(Text("Villagers"),
                                displayMode: .inline)
        }
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
