//
//  TodayDodoCodeSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 12/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodayDodoCodeSection: View {
    @EnvironmentObject private var service: DodoCodeService
    
    var body: some View {
        NavigationLink(destination: DodoCodeListView()) {
            if service.isSynching && service.codes.isEmpty {
                RowLoadingView()
            } else if service.codes.first != nil {
                DodoCodeRow(code: service.codes.first!, showButtons: false)
            } else {
                Text("No active Dodo code yet, open your island to visitors by adding your own")
                    .foregroundColor(.acSecondaryText)
            }
        }
        
    }
}

struct TodayDodoCodeSection_Previews: PreviewProvider {
    static var previews: some View {
        TodayDodoCodeSection().environmentObject(DodoCodeService.shared)
    }
}
