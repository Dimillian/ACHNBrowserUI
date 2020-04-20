//
//  EventTextView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/20/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import ACNHEvents

struct EventTextView: View {
    let today = Date()
    
    var body: some View {
        Group {
            if today.isEarthDay {
                Text("Today is Earth Day!")
            } else {
                Text("No events today.")
            }
        }
        .foregroundColor(.secondaryText)
    }
}

struct EventTextView_Previews: PreviewProvider {
    static var previews: some View {
        EventTextView()
    }
}
