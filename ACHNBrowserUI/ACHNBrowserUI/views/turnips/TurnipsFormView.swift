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
    @EnvironmentObject private var subscriptionManager: SubcriptionManager
    @Environment(\.presentationMode) private var presentationMode
    let turnipsViewModel: TurnipsViewModel
    
    @State private var fields = TurnipFields.decode()
    @State private var enableNotifications = AppUserDefaults.isSubscribed == true
    @State private var isSubscribePresented = false

    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    private var saveButton: some View {
        Button(action: save) {
            Text("Save")
        }
        .safeHoverEffectBarItem(position: .trailing)
    }

    private func save() {
        fields.save()
        turnipsViewModel.refreshPrediction()
        if enableNotifications,
            let predictions = turnipsViewModel.predictions,
            subscriptionManager.subscriptionStatus == .subscribed {
            NotificationManager.shared.registerTurnipsPredictionNotification(prediction: predictions)
        } else {
            NotificationManager.shared.removePendingNotifications()
        }
        turnipsViewModel.refreshPendingNotifications()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: "Configuration")) {
                Button(action: {
                    self.fields.clear()
                    self.turnipsViewModel.refreshPrediction()
                }) {
                    Text("Clear all fields").foregroundColor(.secondaryText)
                }
                Toggle(isOn: $enableNotifications) {
                    Text("Receive prices predictions notification")
                }
                .opacity(subscriptionManager.subscriptionStatus == .subscribed ? 1.0 : 0.5)
                .disabled(subscriptionManager.subscriptionStatus != .subscribed)
                if subscriptionManager.subscriptionStatus != .subscribed {
                    Button(action: {
                        self.isSubscribePresented = true
                    }) {
                        Text("You can get daily notifications for your average turnip price by subscribing to AC Helper+")
                            .foregroundColor(.secondaryText)
                            .font(.footnote)
                    }
                }
                
            }
            Section(header: SectionHeaderView(text: "Your in game prices")) {
                HStack {
                    Text("Buy price")
                    TextField("... 🔔 ...", text: $fields.buyPrice)
                        .keyboardType(.numberPad)
                        .foregroundColor(.bell)
                }
                if fields.fields.filter{ !$0.isEmpty }.count == 0 {
                    Text("The more in game buy prices you'll add the better the predictions will be. Your buy price only won't give your correct averages. Add prices from the game as you get them.")
                        .foregroundColor(.secondaryText)
                        .font(.footnote)
                }
                ForEach(weekdays, id: \.self, content: weekdayRow)
            }
        }
        .listStyle(GroupedListStyle())
        .modifier(AdaptsToSoftwareKeyboard())
        .navigationBarItems(trailing: saveButton)
        .navigationBarTitle("Add your turnip prices", displayMode: .inline)
        .sheet(isPresented: $isSubscribePresented, content: { SubscribeView().environmentObject(self.subscriptionManager) })
    }

    private func weekdayRow(_ weekday: String) -> some View {
        HStack {
            Text(weekday)
            Spacer(minLength: 40)
            TextField("AM", text: morningField(for: weekday))
                .keyboardType(.numberPad)
                .foregroundColor(.bell)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: 60)
            TextField("PM", text: afternoonField(for: weekday))
                .keyboardType(.numberPad)
                .foregroundColor(.bell)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: 60)
        }
    }

    private func morningField(for weekday: String) -> Binding<String> {
        let index = weekdays.firstIndex(of: weekday) ?? 0
        return $fields.fields[index * 2]
    }

    private func afternoonField(for weekday: String) -> Binding<String> {
        let index = weekdays.firstIndex(of: weekday) ?? 0
        return $fields.fields[index * 2 + 1]
    }
}

struct TurnipsFormView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsFormView(turnipsViewModel: TurnipsViewModel())
    }
}
