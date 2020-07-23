//
//  MuseumProgressWidget.swift
//  WidgetsExtension
//
//  Created by Thomas Ricouard on 23/07/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import WidgetKit
import Backend

struct MuseumProgressWidgetView: View {
    var model: WidgetModel?
    
    @ViewBuilder
    var body: some View {
        Group {
            HStack {
                Spacer()
                VStack(spacing: 4) {
                    Spacer()
                    if let museum = model?.museumCollection {
                        ForEach(museum) { progress in
                            HStack {
                                Image(uiImage: UIImage(named: progress.category.iconName())!)
                                    .resizable()
                                    .aspectRatio(1, contentMode: .fit)
                                    .frame(height: 24)
                                WidgetProgressBar(progress: CGFloat(progress.have) / CGFloat(progress.total))
                                Text("\(progress.have) / \(progress.total)")
                                    .font(Font.system(size: 12,
                                                      weight: Font.Weight.semibold,
                                                      design: Font.Design.rounded).monospacedDigit())
                                    .foregroundColor(.acText)
                            }
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
        }.background(Color.acBackground)
    }
}

struct MuseumProgressWidget: Widget {
    private let kind: String = "MuseumWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: WidgetProvider()) { entry in
            MuseumProgressWidgetView(model: entry)
        }
        .configurationDisplayName("Museum collection")
        .description("Museum collection progress")
        .supportedFamilies([.systemMedium])
    }
}

struct MuseumProgressWidget_Previews: PreviewProvider {
    static var previews: some View {
        MuseumProgressWidgetView()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
