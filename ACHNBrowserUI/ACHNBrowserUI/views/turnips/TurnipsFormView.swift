//
//  TurnipsFormView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 27/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsFormView: View {
    // MARK: - Properties
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.currentDate) private var currentDate
    
    @State private var fields = TurnipFields.decode()
    @State private var enableNotifications = SubscriptionManager.shared.subscriptionStatus == .subscribed
    @State private var isSubscribePresented = false

    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    // MARK: - Computed vars
    private func morningField(for weekday: String) -> Binding<String> {
        let index = weekdays.firstIndex(of: weekday) ?? 0
        return $fields.fields[index * 2]
    }
    
    private func afternoonField(for weekday: String) -> Binding<String> {
        let index = weekdays.firstIndex(of: weekday) ?? 0
        return $fields.fields[index * 2 + 1]
    }
    
    // MARK: - Body
    var body: some View {
        List {
            Group {
                configurationSection
                pricesSection
            }.listRowBackground(Color.acSecondaryBackground)
        }
        .listStyle(InsetGroupedListStyle())
        .modifier(AdaptsToSoftwareKeyboard())
        .navigationBarItems(trailing: saveButton)
        .navigationBarTitle("Add your turnip prices", displayMode: .inline)
        .sheet(isPresented: $isSubscribePresented, content: { SubscribeView(source: .turnipForm).environmentObject(self.subscriptionManager) })
    }
}

// MARK: - Views
extension TurnipsFormView {
    private var saveButton: some View {
        Button(action: save) {
            Text("Save")
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private func save() {
        fields.save()
        TurnipPredictionsService.shared.enableNotifications = enableNotifications
        TurnipPredictionsService.shared.fields = fields
        presentationMode.wrappedValue.dismiss()
    }
    
    private var amountTextField: some View {
        let amount = Binding<String>(
            get: {
                String(self.fields.amount)
        }, set: {
            self.fields.amount = Int($0) ?? 0
        })
        return TextField("... 📈 ...", text: amount)
            .keyboardType(.numberPad)
            .foregroundColor(.acHeaderBackground)
    }
    
    private var configurationSection: some View {
        Section(header: SectionHeaderView(text: "Configuration")) {
            Button(action: {
                self.fields.clear()
            }) {
                Text("Clear all fields").foregroundColor(.acSecondaryText)
            }
            Toggle(isOn: $enableNotifications) {
                Text("Receive prices predictions notification")
            }
            .opacity(subscriptionManager.subscriptionStatus == .subscribed ? 1.0 : 0.7)
            .disabled(subscriptionManager.subscriptionStatus != .subscribed)
            if subscriptionManager.subscriptionStatus != .subscribed {
                Button(action: {
                    self.isSubscribePresented = true
                }) {
                    Text("You can get daily notifications for your average turnip price by subscribing to AC Helper+")
                        .foregroundColor(.acSecondaryText)
                        .font(.footnote)
                }
            }
            Button(action: {
                NotificationManager.shared.testNotification()
            }) {
                Text("Preview a notification").foregroundColor(.acHeaderBackground)
            }
            
        }
    }
    
    private var pricesSection: some View {
        Section(header: SectionHeaderView(text: "Your in game prices")) {
            HStack {
                Text("Buy price")
                Spacer()
                TextField("... 🔔 ...", text: $fields.buyPrice)
                    .keyboardType(.numberPad)
                    .foregroundColor(.acHeaderBackground)
            }
            HStack {
                Text("Amount bought")
                amountTextField
            }
            if fields.fields.filter{ !$0.isEmpty }.count == 0 {
                Text("The more in game buy prices you'll add the better the predictions will be. Your buy price only won't give your correct averages. Add prices from the game as you get them daily.")
                    .foregroundColor(.acSecondaryText)
                    .font(.footnote)
            }
            ForEach(weekdays, id: \.self, content: makeWeekdayRow)
        }
    }
    
    private func makeWeekdayRow(_ weekday: String) -> some View {
        HStack {
            Text(LocalizedStringKey(weekday))
            Spacer(minLength: 40)
            TextField("AM", text: morningField(for: weekday))
                .keyboardType(.numberPad)
                .foregroundColor(.acHeaderBackground)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: 60)
            TextField("PM", text: afternoonField(for: weekday))
                .keyboardType(.numberPad)
                .foregroundColor(.acHeaderBackground)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: 60)
        }
    }
}

struct TurnipsFormView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsFormView()
            .environmentObject(SubscriptionManager.shared)
    }
}
