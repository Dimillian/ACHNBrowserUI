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
    let todayEvents = Date().events(for: .north)
    let nextEvent = Event.nextEvent()
    
    func makeDateBadge(date: Date) -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return Text(formatter.string(from: date))
            .foregroundColor(.white)
            .font(.caption)
            .fontWeight(.bold)
            .padding(8)
            .background(Color.grass)
            .cornerRadius(20)
    }
    
    var body: some View {
        Group {
            if !todayEvents.isEmpty {
                Text("Today is \(todayEvents.first!.title()) ")
            } else if nextEvent.1 != nil {
                HStack {
                    Text("Next event: \(nextEvent.1!.title())!")
                    Spacer()
                    makeDateBadge(date: nextEvent.0)
                }
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
