//
//  TodaySectionEditView.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend
import Combine

struct TodaySectionEditView: View {
    @Environment(\.presentationMode) private var presentationMode

    @ObservedObject var viewModel: DashboardViewModel

    @State private var editMode = EditMode.active

    var body: some View {
        List(selection: self.$viewModel.selection) {
            Section(header: SectionHeaderView(text: "Drag & Drop to Rearrange",
                                              icon: "arrow.up.arrow.down.circle.fill"),
                    footer: self.footer) {
                ForEach(viewModel.sectionOrder, id: \.name) { section in
                    HStack {
                        Image(systemName: section.iconName)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(.acSecondaryText)
                        
                        Text(LocalizedStringKey(section.sectionName))
                            .font(.system(.body, design: .rounded))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .onMove(perform: onMove)
            }
        }
        .onDisappear(perform: self.viewModel.saveSectionList)
        .listStyle(GroupedListStyle())
        .environment(\.editMode, $editMode)
        .navigationBarTitle("Today Sections")
        .navigationBarItems(trailing: dismissButton)
    }
    
    private var dismissButton: some View {
        Button(action: { self.presentationMode.wrappedValue.dismiss() }) {
            Text("Done")
                .font(.system(size: 16, weight: .bold, design: .rounded))
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).foregroundColor(Color.acText.opacity(0.2)))
    }
    
    // @TODO: Do we need explainer text? 
    private var footer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drag and drop").fontWeight(.bold) + Text(" to re-order sections.")
            Text("Check or un-check").fontWeight(.bold) + Text(" rows to hide sections from the dashboard.")
        }
        .padding(.vertical)
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        viewModel.sectionOrder.move(fromOffsets: source, toOffset: destination)
    }
}

extension TodaySection {
    var sectionName: String {
        switch name {
        case .events: return "Events"
        case .specialCharacters: return "Possible visitors"
        case .currentlyAvailable: return "Currently Available"
        case .collectionProgress: return "Collection Progress"
        case .birthdays: return "Today's Birthdays"
        case .turnips: return "Turnips"
        case .subscribe: return "Subscribe"
        case .mysteryIsland: return "Mystery Islands"
        case .music: return "Music player"
        case .tasks: return "Today's Tasks"
        case .nookazon: return "New on Nookazon"
        }
    }

    var iconName: String {
        switch name {
        case .events: return "flag.fill"
        case .specialCharacters: return "clock"
        case .currentlyAvailable: return "calendar"
        case .collectionProgress: return "chart.pie.fill"
        case .birthdays: return "gift.fill"
        case .turnips: return "dollarsign.circle.fill"
        case .subscribe: return "suit.heart.fill"
        case .mysteryIsland: return "sun.haze.fill"
        case .music: return "music.note"
        case .tasks: return "checkmark.seal.fill"
        case .nookazon: return "cart.fill"
        }
    }
}

struct TodaySectionEditView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySectionEditView(viewModel: DashboardViewModel())
    }
}
