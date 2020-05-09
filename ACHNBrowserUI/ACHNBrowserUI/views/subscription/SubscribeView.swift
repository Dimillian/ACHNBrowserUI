//
//  SubscribeView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend
import Purchases

struct SubscribeView: View {
    @EnvironmentObject private var subscriptionManager: SubcriptionManager
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var sheetURL: URL?
    
    private var sub: Purchases.Package? {
        subscriptionManager.subscription
    }
    
    private var price: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = sub!.product.priceLocale
        return formatter.string(from: sub!.product.price)!
    }
    
    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Close")
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var upperPart: some View {
        Group {
            HStack(alignment: .center, spacing: 4) {
                Text("Upgrade to +")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.acHeaderBackground)
                Image("icon-bell")
            }
            .padding(.top, 32)
            Image("notification")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 320)
            Button(action: {
                NotificationManager.shared.testNotification()
            }) {
                Text("Tap here to preview a notification").foregroundColor(.acHeaderBackground)
            }
            Text("""
                            Subscribing to AC Helper+ is a great way to to show support to our free and open source project.♥️

                            You also get access more features, turnip predictions notifications and creating any number of items list! 📈

                            More detail below.
                            """)
                .font(.body)
                .foregroundColor(.acText)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            makeBorderedButton(action: {
                if self.subscriptionManager.subscriptionStatus == .subscribed {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.subscriptionManager.puschase(product: self.sub!)
                }
            }, label: self.subscriptionManager.subscriptionStatus == .subscribed ?
                "Thanks you for your support!" :
                "Subscribe for \(price) / Month")
            .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
            .disabled(subscriptionManager.inPaymentProgress)

        }
    }
    
    private func makeBorderedButton(action: @escaping () -> Void, label: String) -> some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(width: 290, height: 30)
        }.buttonStyle(PlainRoundedButton()).accentColor(.acTabBarTint).safeHoverEffect()
    }
    
    private var lowerPart: some View {
        Group {
            Text("""
                About the notification feature:
                Everyday at 8 and 12 you'll get a notification with the average buy price of your store.
                The more in game daily prices you enter after monday morning, the better next predictions will be!

                About the list feature:
                In the free application you can create only one list of items in your "My stuff" tab.
                Once you'll be subscribed to AC Helper+ you'll be able to create any number of list you desire.
                """)
                .font(.body)
                .foregroundColor(.acText)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            Spacer(minLength: 16)
            Text("""
                A \(price) per month purchase will be applied to your iTunes account on confirmation.
                Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period.
                You can cancel anytime with your iTunes account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription.
                """)
                .font(.caption)
                .foregroundColor(.acText)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            Spacer(minLength: 16)
            makeBorderedButton(action: {
                self.sheetURL = URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/privacy-policy.md#ac-helper-privacy-policy")
            }, label: "Privacy policy")
            
            Spacer(minLength: 16)
            makeBorderedButton(action: {
                self.sheetURL = URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/term-of-use.md#ac-helper-term-of-use")
            }, label: "Term of Use")
            Spacer(minLength: 32)
        }.background(Color.acBackground.edgesIgnoringSafeArea(.all))
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack {
                    Color.acBackground.edgesIgnoringSafeArea(.all)
                    if sub != nil {
                        VStack {
                            upperPart
                            Spacer(minLength: 32)
                            lowerPart
                        }
                    } else {
                        Text("Loading...")
                        Spacer()
                    }
                }
            }
            .sheet(item: $sheetURL, content: { SafariView(url: $0) })
            .navigationBarItems(trailing: dismissButton)
            .navigationBarTitle(Text("AC Helper+"),
                                displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SubscribeViewPreviews: PreviewProvider {
    static var previews: some View {
        SubscribeView()
    }
}
