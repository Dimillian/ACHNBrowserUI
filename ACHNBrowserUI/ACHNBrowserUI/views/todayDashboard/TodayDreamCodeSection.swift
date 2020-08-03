//
//  TodayDreamCodeSection.swift
//  ACHNBrowserUI
//
//  Created by Jan van Heesch on 02.08.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodayDreamCodeSection: View {
    @EnvironmentObject private var service: DreamCodeService
    
    var body: some View {
        NavigationLink(destination: DreamCodeListView()) {
            if service.isSynching && service.codes.isEmpty {
                RowLoadingView()
            } else if service.codes.first != nil {
                DreamCodeRow(code: service.codes.first!, showButtons: false)
            } else {
                Text("There are no dream codes yet. Visit Luna in your dreams, generate your islands dream code and add it here.")
                    .foregroundColor(.acSecondaryText)
            }
        }
        
    }
}

struct TodayDreamCodeSection_Previews: PreviewProvider {
    static var previews: some View {
        TodayDreamCodeSection().environmentObject(DreamCodeService.shared)
    }
}
