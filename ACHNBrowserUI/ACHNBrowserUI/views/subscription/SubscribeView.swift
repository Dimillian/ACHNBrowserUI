//
//  SubscribeView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import Purchases

struct SubscribeView: View {
    @EnvironmentObject private var subscriptionManager: SubcriptionManager
    @Environment(\.presentationMode) private var presentationMode
    
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
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                ZStack {
                    Color.dialogueReverse.edgesIgnoringSafeArea(.all)
                    if sub != nil {
                        VStack {
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
                                .padding()
                            Text("""
                            Subscribing to AC Helper+ is a great way to to show support to our free and open source project.♥️

                            You also get access to a great feature, turnip predictions notifications! 📈

                            Everyday at 8 and 12 you'll get a notification with the average buy price of your store.

                            The more in game daily prices you enter after monday morning, the better next predictions will be!

                            """)
                                .font(.body)
                                .foregroundColor(.text)
                                .frame(width: 320)
                                .padding()
                                .lineLimit(nil)
                            Button(action: {
                                if self.subscriptionManager.subscriptionStatus == .subscribed {
                                    self.presentationMode.wrappedValue.dismiss()
                                } else {
                                    self.subscriptionManager.puschase(product: self.sub!)
                                }
                            }) {
                                Group {
                                    if self.subscriptionManager.subscriptionStatus == .subscribed {
                                        Text("Thanks you for your support!")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    } else {
                                        Text("Subscribe for \(price) / Month")
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                    }
                                }
                                .font(.headline)
                                .frame(width: 320, height: 50)
                                .background(Color.grass)
                                .cornerRadius(8)
                            }
                            .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
                            .disabled(subscriptionManager.inPaymentProgress)
                            Spacer(minLength: 300)
                        }.background(Color.dialogueReverse.edgesIgnoringSafeArea(.all))
                    } else {
                        Text("Loading...")
                        Spacer()
                    }
                }
            }
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
