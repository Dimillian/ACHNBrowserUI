//
//  TodayEventsSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/8/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import ACNHEvents
import Backend

struct TodayEventsSection: View {
    @Environment(\.currentDate) private var currentDate

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                subsectionHeader("Currently").padding(.top, 4)
                
                if todaysEvents.isEmpty {
                    self.makeLabel("No Events Today").padding(.vertical, 8)
                } else {
                    ForEach(todaysEvents, id: \.self) { event in
                        self.makeLabel(event.title())
                    }
                }
            }
            
            if nextEvent.1 != nil && !todaysEvents.contains(nextEvent.1!) {
                Divider()
                VStack(alignment: .leading) {
                    subsectionHeader("Upcoming")
                    self.makeCell(event: nextEvent)
                }
            }
        }
    }

    private var todaysEvents: [Event] {
        currentDate.events(for: AppUserDefaults.shared.hemisphere == .north ? .north : .south)
    }

    private var nextEvent: (Date, Event?) { Event.nextEvent(today: currentDate) }

    private func subsectionHeader(_ text: String) -> some View {
        Text(LocalizedStringKey(text))
            .font(.system(.caption, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.acSecondaryText)
            .padding(.top, 4)
    }

    private func makeCell(event: (Date, Event?)) -> some View {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM dd")
        let date: String = formatter.string(from: event.0)

        return HStack {
            makeLabel(event.1!.title())

            Spacer()

            Text("\(date)")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.acText)
                .frame(minWidth: 50)
                .padding(10)
                .background(Color.acText.opacity(0.2))
                .mask(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .padding(.bottom, 4)
    }

    private func makeLabel(_ text: String) -> some View {
        Text(LocalizedStringKey(text))
            .font(Font.system(.headline, design: .rounded))
            .fontWeight(.semibold)
            .lineLimit(2)
            .foregroundColor(.acText)
    }
}

struct TodayEventsSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayEventsSection()
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
