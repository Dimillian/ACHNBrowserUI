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
        case dashboard, turnip, turnipForm, list
    }
    
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.presentationMode) private var presentationMode
    
    let source: Source
    @State private var sheetURL: URL?
    
    private var sub: Purchases.Package? {
        subscriptionManager.subscription
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
            Text("ACHelperPlusDescription")
                .font(.body)
                .foregroundColor(.acText)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            
            makeBorderedButton(action: {
                if self.subscriptionManager.subscriptionStatus == .subscribed {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.subscriptionManager.purchase(source: self.source.rawValue,
                                                      product: self.sub!)
                }
            }, label: self.subscriptionManager.subscriptionStatus == .subscribed ?
                NSLocalizedString("Thank you for your support!", comment: "") :
                NSLocalizedString("Subscribe for \(formattedPrice(for: sub!)) / Month", comment: ""))
            .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
            .disabled(subscriptionManager.inPaymentProgress)
            
            makeBorderedButton(action: {
                if self.subscriptionManager.subscriptionStatus == .subscribed {
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    self.subscriptionManager.purchase(source: self.source.rawValue,
                                                      product: self.lifetime!)
                }
            }, label: self.subscriptionManager.subscriptionStatus == .subscribed ?
                NSLocalizedString("Thank you for your support!", comment: "") :
                NSLocalizedString("Buy lifetime AC Helper+ for \(formattedPrice(for: lifetime!))", comment: ""))
                .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
                .disabled(subscriptionManager.inPaymentProgress)
                .padding(.top, 16)

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
            Text("ACHelperPlusDetails")
                .font(.body)
                .foregroundColor(.acText)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            Spacer(minLength: 16)
            Text("ACHelperPlusPriceAndAboDetail \(formattedPrice(for: sub!))")
                .font(.caption)
                .foregroundColor(.acText)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            Spacer(minLength: 16)
            makeBorderedButton(action: {
                self.sheetURL = URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/privacy-policy.md#ac-helper-privacy-policy")
            }, label: NSLocalizedString("Privacy Policy", comment: ""))
            
            Spacer(minLength: 16)
            makeBorderedButton(action: {
                self.sheetURL = URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/term-of-use.md#ac-helper-term-of-use")
            }, label: NSLocalizedString("Terms of Use", comment: ""))
            Spacer(minLength: 32)
        }.background(Color.acBackground.edgesIgnoringSafeArea(.all))
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack {
                    Color.acBackground.edgesIgnoringSafeArea(.all)
                    if sub != nil && lifetime != nil {
                        VStack {
                            upperPart
                            Spacer(minLength: 32)
                            lowerPart
                        }
                    } else {
                        RowLoadingView(isLoading: .constant(true))
                        Spacer()
                    }
                }
            }
            .sheet(item: $sheetURL, content: { SafariView(url: $0) })
            .navigationBarItems(leading: dismissButton)
            .navigationBarTitle(Text("AC Helper+"),
                                displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SubscribeViewPreviews: PreviewProvider {
    static var previews: some View {
        SubscribeView(source: .list)
    }
}
