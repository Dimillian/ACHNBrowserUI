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
                    .foregroundColor(.bell)
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
                Text("Tap here to preview a notification").foregroundColor(.bell)
            }
            Text("ACHelperPlusDescription")
                .font(.body)
                .foregroundColor(.text)
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
                NSLocalizedString("Thank you for your support!", comment: "") :
                NSLocalizedString("Subscribe for \(price) / Month", comment: ""))
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
        }.buttonStyle(PlainRoundedButton()).accentColor(.grass).safeHoverEffect()
    }
    
    private var lowerPart: some View {
        Group {
            Text("ACHelperPlusDetails")
                .font(.body)
                .foregroundColor(.text)
                .frame(width: 320)
                .padding()
                .lineLimit(nil)
            Spacer(minLength: 16)
            Text("ACHelperPlusPriceAndAboDetail \(price)")
                .font(.caption)
                .foregroundColor(.text)
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
            }, label: "Term of Use")
            Spacer(minLength: 32)
        }.background(Color.dialogueReverse.edgesIgnoringSafeArea(.all))
    }

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack {
                    Color.dialogueReverse.edgesIgnoringSafeArea(.all)
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
