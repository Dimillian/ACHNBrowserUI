//
//  DashboardEventTextView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/20/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import ACNHEvents
import Backend

struct DashboardEventTextView: View {
    let todayEvents = Date().events(for: AppUserDefaults.hemisphere == .north ? .north : .south)
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
            VStack(alignment: .leading) {
                if !todayEvents.isEmpty && todayEvents.count == 1 {
                    Text("Today is \(todayEvents.first!.title())!")
                } else if todayEvents.count > 1 {
                    Text("Today events are ") +
                        Text("\(todayEvents.first!.title())")
                            .foregroundColor(.bell)
                            .fontWeight(.semibold) +
                        Text(" and ") +
                        Text("\(todayEvents.last!.title())")
                            .foregroundColor(.bell)
                            .fontWeight(.semibold)
                } else {
                    Text("No events today.")
                }
                if nextEvent.1 != nil && nextEvent.1 != todayEvents.first {
                    HStack {
                        Text("Next event: \(nextEvent.1!.title())!")
                        Spacer()
                        makeDateBadge(date: nextEvent.0)
                    }
                }
            }
        }
        .foregroundColor(.secondaryText)
    }
}

struct EventTextView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardEventTextView()
    }
}
