//
//  ResidentButton.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 07/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ResidentButton: View {
    @EnvironmentObject private var collection: UserCollection
    let villager: Villager
    
    var body: some View {
        Button(action: {
            _ = self.collection.toggleResident(villager: self.villager)
            FeedbackGenerator.shared.triggerNotification(type: .success)
        }) {
            Image(systemName: collection.residents.contains(villager) ? "house.fill" : "house")
                .foregroundColor(.acTabBarBackground)
                .imageScale(.medium)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct ResidentButton_Previews: PreviewProvider {
    static var previews: some View {
        ResidentButton(villager: static_villager).environmentObject(UserCollection.shared)
    }
}
