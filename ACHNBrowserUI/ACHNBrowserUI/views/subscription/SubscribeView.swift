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
    enum Source: String {
        case dashboard, turnip, turnipForm, list, musics, dodo
    }
    
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.presentationMode) private var presentationMode
    
    let source: Source
    @State private var sheetURL: URL?
    
    private var sub: Purchases.Package? {
        subscriptionManager.monthlySubscription
    }
    
    private var yearlySub: Purchases.Package? {
        subscriptionManager.yearlySubscription
    }
    
    private var lifetime: Purchases.Package? {
        subscriptionManager.lifetime
    }
    
    private func formattedPrice(for package: Purchases.Package) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = sub!.product.priceLocale
        return formatter.string(from: package.product.price)!
    }
    
    
    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ZStack(alignment: .bottom) {
                    Color.acBackground.edgesIgnoringSafeArea(.all)
                    ScrollView(.vertical, showsIndicators: false) {
                        self.content
                            .frame(width: proxy.size.width * 0.9)
                    }
                    self.paymentButtons
                        .frame(width: proxy.size.width,
                               height: 170)
                        .background(Color.acSecondaryBackground)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .sheet(item: $sheetURL, content: { SafariView(url: $0) })
            .navigationBarItems(leading: dismissButton)
            .navigationBarTitle(Text("AC Helper+"),
                                displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        })
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffectBarItem(position: .leading)
    }
    
    private var content: some View {
        VStack {
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
                    .frame(maxHeight: 100)
                Button(action: {
                    NotificationManager.shared.testNotification()
                }) {
                    Text("Tap here to preview a notification").foregroundColor(.acHeaderBackground)
                }
                Text("ACHelperPlusDescription")
                    .font(.body)
                    .foregroundColor(.acText)
                    .padding()
                    .lineLimit(nil)
            }
            
            Group {
                Text("ACHelperPlusDetails")
                    .font(.body)
                    .foregroundColor(.acText)
                    .padding()
                    .lineLimit(nil)
                Spacer(minLength: 16)
                if sub != nil && yearlySub != nil {
                    Text("ACHelperPlusPriceAndAboDetail \(formattedPrice(for: sub!)) \(formattedPrice(for: yearlySub!))")
                        .font(.caption)
                        .foregroundColor(.acText)
                        .padding()
                        .lineLimit(nil)
                }
                Spacer(minLength: 16)
                makeBorderedButton(action: {
                                    self.sheetURL = URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/main/privacy-policy.md#ac-helper-privacy-policy")
                }, label: "Privacy Policy")
                
                Spacer(minLength: 16)
                makeBorderedButton(action: {
                                    self.sheetURL = URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/main/term-of-use.md#ac-helper-term-of-use")
                }, label: "Terms of Use")
            }
            Spacer(minLength: 200)
        }
    }
    
    private var paymentButtons: some View {
        VStack {
            if sub == nil && yearlySub == nil && lifetime == nil {
                RowLoadingView()
            } else {
                HStack(spacing: 0) {
                    sub.map{ sub in
                        makeBorderedButton(action: {
                            self.buttonAction(purchase: sub)
                        }, label: self.subscriptionManager.subscriptionStatus == .subscribed ?
                            "Thanks!" :
                            "\(formattedPrice(for: sub)) Monthly")
                            .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
                            .disabled(subscriptionManager.inPaymentProgress)
                    }
                    
                    Spacer(minLength: 18)
                    
                    yearlySub.map{ yearlySub in
                        makeBorderedButton(action: {
                            self.buttonAction(purchase: yearlySub)
                        }, label: self.subscriptionManager.subscriptionStatus == .subscribed ?
                            "Thanks!" :
                            "\(formattedPrice(for: yearlySub)) Yearly")
                            .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
                            .disabled(subscriptionManager.inPaymentProgress)
                    }
                }
                
                lifetime.map{ lifetime in
                    makeBorderedButton(action: {
                        self.buttonAction(purchase: lifetime)
                    }, label: self.subscriptionManager.subscriptionStatus == .subscribed ?
                        "Thank you for your support!" :
                        "Buy lifetime AC Helper+ for \(formattedPrice(for: lifetime))")
                        .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
                        .disabled(subscriptionManager.inPaymentProgress)
                        .padding(.top, 16)
                }
            }
        }.frame(maxWidth: 320)
    }
    
    private func buttonAction(purchase: Purchases.Package) {
        if subscriptionManager.subscriptionStatus == .subscribed {
            presentationMode.wrappedValue.dismiss()
        } else {
            subscriptionManager.purchase(source: self.source.rawValue,
                                         product: purchase)
        }
    }
    
    private func makeBorderedButton(action: @escaping () -> Void, label:
        LocalizedStringKey) -> some View {
        Button(action: action) {
            Text(label)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .minimumScaleFactor(0.01)
                .lineLimit(1)
                .frame(maxWidth: .infinity,
                       maxHeight: 30)
        }.buttonStyle(PlainRoundedButton()).accentColor(.acTabBarTint).safeHoverEffect()
    }
}

struct SubscribeViewPreviews: PreviewProvider {
    static var previews: some View {
        SubscribeView(source: .list)
            .environmentObject(SubscriptionManager.shared)
    }
}
