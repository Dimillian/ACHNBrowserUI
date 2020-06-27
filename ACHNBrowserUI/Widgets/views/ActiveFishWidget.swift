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
                .font(Font.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.acText)
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

struct CritterRows: View {
    let critters: [Item]
    
    var body: some View {
        HStack {
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
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct ActiveFishWidget_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
