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
            Text("To catch now")
                .foregroundColor(.acText)
                .fontWeight(.bold)
                .font(.title2)
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
                    HStack {
                        ForEach(critters.prefix(3)) { critter in
                            Spacer()
                            CritterRow(critter: critter)
                            Spacer()
                        }
                    }
                }
                
            case .systemLarge:
                if let critters = model.availableFishes {
                    ForEach(critters.prefix(3)) { critter in
                        CritterRow(critter: critter)
                    }
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
            WebImage(url: ImageService.computeUrl(key: critter.finalImage!))
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .animation(.spring())
            Text(critter.name).foregroundColor(.acText)
        }
    }
}

struct ActiveFishWidget: Widget {
    private let kind: String = "ActiveFish"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider(),
                            placeholder: PlaceholderView()) { entry in
            ActiveFishWidgetView(model: entry)
        }
        .configurationDisplayName("Acive fish")
        .description("Fish that you can catch right now!")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
