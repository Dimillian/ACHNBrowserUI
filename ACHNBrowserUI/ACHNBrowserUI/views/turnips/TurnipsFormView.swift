//
//  TurnipsFormView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 27/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI


struct TurnipsFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    let turnipsViewModel: TurnipsViewModel
    
    @State private var fields = TurnipFields.decode()
    
    private let labels = ["Monday AM", "Monday PM", "Tuesday AM", "Tuesday PM", "Wednesday AM", "Wednesday PM",
                          "Thursday AM", "Thursday PM", "Friday AM", "Friday PM", "Saturday AM", "Saturday PM"]

    private var saveButton: some View {
        Button(action: {
            self.fields.save()
            self.turnipsViewModel.refreshPrediction()
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        })
    }
    
    var body: some View {
        NavigationView {
            List {
                Button(action: {
                    self.fields.clear()
                    self.turnipsViewModel.refreshPrediction()
                }) {
                    Text("Clear all fields").foregroundColor(.secondaryText)
                }
                
                TextField("Buy price", text: $fields.buyPrice)
                    .keyboardType(.numberPad)
                ForEach(0..<fields.fields.count) { i in
                    TextField(self.labels[i], text: self.$fields.fields[i])
                        .keyboardType(.numberPad)
                }
            }
            .navigationBarItems(trailing: saveButton)
            .navigationBarTitle("Add your turnip prices", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TurnipsFormView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsFormView(turnipsViewModel: TurnipsViewModel())
    }
}
