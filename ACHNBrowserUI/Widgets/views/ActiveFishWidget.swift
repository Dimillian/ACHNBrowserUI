//
//  ActiveFishesWidget.swift
//  WidgetsExtension
//
//  Created by Thomas Ricouard on 23/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import WidgetKit
import SwiftUI
import Backend
import SDWebImageSwiftUI

struct ActiveFishWidgetView : View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var model: WidgetModel
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
            switch family {
            case .systemSmall:
                if let critter = model.availableFishes?.first {
                    CritterRow(critter: critter)
                }
            case .systemMedium:
                if let critters = model.availableFishes {
                    CritterRows(critters: critters)
                }
                
            case .systemLarge:
                if let critters = model.availableFishes {
                    CritterRows(critters: critters)
                }
            @unknown default:
                Text("Not supported")
            }
            Spacer()
        }.background(Color.acBackground)
    }
}

private struct CritterRow: View {
    let critter: Item
    
    var body: some View {
        VStack {
            Text(critter.name)
                .font(.callout)
                .foregroundColor(.acText)
            Text(critter.obtainedFrom ?? critter.obtainedFromNew?.first ?? "Unknown")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.acSecondaryText)
            Spacer()
            WebImage(url: ImageService.computeUrl(key: critter.finalImage!))
                .resizable()
                .renderingMode(.original)
                .placeholder(content: {
                    ContainerRelativeShape()
                        .fill(Color.acSecondaryBackground)
                })
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)
                .animation(.spring())
            Spacer()
            if let hours = critter.activeHours(), hours.0 != 0, hours.1 != 0 {
                let endDate = Calendar.current.date(bySettingHour: hours.1, minute: 0, second: 0, of: Date())!
                HStack {
                    Text(endDate, style: .relative)
                        .font(.caption)
                        .foregroundColor(.acText)
                }
            } else {
                Text("All day")
                    .font(.caption)
                    .foregroundColor(.acText)
            }
        }
    }
}

struct CritterRows: View {
    let critters: [Item]
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(critters) { critter in
                Spacer()
                CritterRow(critter: critter)
                Spacer()
            }
        }
    }
}

struct ActiveFishWidget: Widget {
    private let kind: String = "ActiveFish"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: WidgetProvider(),
                            placeholder: LoadingView()) { entry in
            ActiveFishWidgetView(model: entry)
        }
        .configurationDisplayName("Active fish")
        .description("See a random fish that you can catch right now!")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct ActiveFishWidget_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
