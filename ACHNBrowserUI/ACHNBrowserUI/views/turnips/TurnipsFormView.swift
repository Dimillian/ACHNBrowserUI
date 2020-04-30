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
    @Environment(\.presentationMode) private var presentationMode
    let turnipsViewModel: TurnipsViewModel
    
    @State private var fields = TurnipFields.decode()
    @State private var enableNotifications = true
    
    private let labels = ["Monday AM", "Monday PM", "Tuesday AM", "Tuesday PM", "Wednesday AM", "Wednesday PM",
                          "Thursday AM", "Thursday PM", "Friday AM", "Friday PM", "Saturday AM", "Saturday PM"]

    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    private var saveButton: some View {
        Button(action: save) {
            Text("Save")
        }
    }

    private func save() {
        fields.save()
        turnipsViewModel.refreshPrediction()
        if enableNotifications, let predictions = turnipsViewModel.predictions {
            NotificationManager.shared.registerTurnipsPredictionNotification(prediction: predictions)
        } else {
            NotificationManager.shared.removePendingNotifications()
        }
        turnipsViewModel.refreshPendingNotifications()
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
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
                    
                }
                Section(header: SectionHeaderView(text: "Your in game prices")) {
                    HStack {
                        Text("Buy price")
                        TextField("... 🔔 ...", text: $fields.buyPrice)
                            .keyboardType(.numberPad)
                    }
                    ForEach(weekdays, id: \.self, content: weekdayRow)
                }
            }
            .listStyle(GroupedListStyle())
            .modifier(AdaptsToSoftwareKeyboard())
            .navigationBarItems(trailing: saveButton)
            .navigationBarTitle("Add your turnip prices", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private func weekdayRow(_ weekday: String) -> some View {
        HStack {
            Text(weekday)
            Spacer(minLength: 40)
            TextField("AM", text: morningField(for: weekday))
                .keyboardType(.numberPad)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .multilineTextAlignment(.center)
                .frame(maxWidth: 60)
            TextField("PM", text: afternoonField(for: weekday))
                .keyboardType(.numberPad)
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
