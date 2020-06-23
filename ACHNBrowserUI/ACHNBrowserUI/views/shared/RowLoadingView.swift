//
//  RowLoadingView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct RowLoadingView: View {
    @Binding var isLoading: Bool
    
    var body: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }.background(Color.acSecondaryBackground)
    }
}

struct RowLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        RowLoadingView(isLoading: .constant(true))
    }
}
