//
//  DodoCodeListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 12/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Backend

struct DodoCodeListView: View {
    @EnvironmentObject private var service: DodoCodeService
    
    @State private var sheet: Sheet.SheetType?
    @State private var showiCloudAlert = false
    
    var body: some View {
        List {
            if service.isSynching && service.codes.isEmpty {
                RowLoadingView(isLoading: .constant(true))
            } else if !service.codes.isEmpty {
                ForEach(service.codes) { code in
                    DodoCodeRow(code: code)
                }
            } else {
                Text("No active Dodo code yet, open your island to visitors by adding your own")
                    .foregroundColor(.acSecondaryText)
            }
        }
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
        .alert(isPresented: $showiCloudAlert, content: { self.iCloudAlert })
        .navigationBarTitle("Dodo codes")
        .navigationBarItems(trailing:
            HStack(spacing: 8) {
                refreshButton
                addButton
            }
        )
        .onAppear(perform: service.refresh)
    }
    
    private var iCloudAlert: Alert {
        Alert(title: Text("iCloud not enabled"),
              message: Text("You need an iCloud account to add your Dodo code"),
              dismissButton: .default(Text("Ok")))
    }
    
    private var addButton: some View {
        Button(action: {
            if !self.service.canEdit {
                self.showiCloudAlert = true
                return
            }
            self.sheet = .dodoCodeForm
        }) {
            Image(systemName: "plus.circle").imageScale(.large)
        }
    }
    
    private var refreshButton: some View {
        Button(action: {
            self.service.refresh()
        }) {
            if service.isSynching {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                Image(systemName: "arrow.counterclockwise.circle").imageScale(.large)
            }
        }
    }
}
