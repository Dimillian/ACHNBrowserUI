//
//  TodaySubscribeCard.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodaySubscribeSection: View {
    @Binding var sheet: Sheet.SheetType?
    @EnvironmentObject private var subManager: SubscriptionManager
    
    var body: some View {
        HStack {
            Image(systemName: "heart.circle")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.red)
                .frame(maxWidth: 33)
            Group {
                if subManager.subscriptionStatus == .subscribed {
                    Text("You're subscribed to AC Helper+. Thank you so much for you support!")
                } else {
                    Button(action: {
                        self.sheet = .subscription(source: .dashboard, subManager: self.subManager)
                    }) {
                        Text("If you enjoy the application, consider subscribing to AC Helper+, to get access to some awesome features and support us!")
                    }
                }
            }
            .font(.system(.body, design: .rounded))
            .foregroundColor(.acText)
            
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical)
    }
}

struct TodaySubscribeCard_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TodaySubscribeSection(sheet: .constant(nil))
                .environmentObject(SubscriptionManager.shared)
        }
        .listStyle(InsetGroupedListStyle())
    }
}
