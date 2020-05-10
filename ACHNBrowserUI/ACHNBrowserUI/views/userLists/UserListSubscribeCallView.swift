//
//  UserListSubscribeCallView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct UserListSubscribeCallView: View {
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    
    @Binding var sheet: Sheet.SheetType?
    
    var body: some View {
        VStack(spacing: 8) {
            Button(action: {
                self.sheet = .subscription(source: .list, subManager: self.subscriptionManager)
            }) {
                Text("In order to create more than one list, you need to subscribe to AC Helper+")
                    .foregroundColor(.acSecondaryText)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 8)
            }
            Button(action: {
                self.sheet = .subscription(source: .list, subManager: self.subscriptionManager)
            }) {
                Text("Learn more...")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }.buttonStyle(PlainRoundedButton())
                .accentColor(.acHeaderBackground)
                .padding(.bottom, 8)
        }
    }
}

struct UserListSubscribeCallView_Previews: PreviewProvider {
    static var previews: some View {
        UserListSubscribeCallView(sheet: .constant(nil))
    }
}
