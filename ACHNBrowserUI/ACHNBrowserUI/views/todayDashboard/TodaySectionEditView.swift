//
//  TodaySectionEditView.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend

struct TodaySectionEditView: View {
    @Environment(\.presentationMode) private var presentationMode

    @ObservedObject var viewModel: DashboardViewModel

    @State private var editMode = EditMode.active

    private let textForSectionName = [
        TodaySection.nameEvents: "Events",
        TodaySection.nameSpecialCharacters: "Possible visitors",
        TodaySection.nameCurrentlyAvailable: "Currently Available",
        TodaySection.nameCollectionProgress: "Collection Progress",
        TodaySection.nameBirthdays: "Today's Birthdays",
        TodaySection.nameTurnips: "Turnips",
        TodaySection.nameSubscribe: "Subscribe",
        TodaySection.nameMysteryIsland: "Mystery Islands",
        TodaySection.nameMusic: "Music player",
        TodaySection.nameTasks: "Today's Tasks",
        TodaySection.nameNookazon: "New on Nookazon"
    ]
    
    private let iconForSectionName = [
        TodaySection.nameEvents: "flag.fill",
        TodaySection.nameSpecialCharacters: "clock",
        TodaySection.nameCurrentlyAvailable: "calendar",
        TodaySection.nameCollectionProgress: "chart.pie.fill",
        TodaySection.nameBirthdays: "gift.fill",
        TodaySection.nameTurnips: "dollarsign.circle.fill",
        TodaySection.nameSubscribe: "suit.heart.fill",
        TodaySection.nameMysteryIsland: "sun.haze.fill",
        TodaySection.nameMusic: "music.note",
        TodaySection.nameTasks: "checkmark.seal.fill",
        TodaySection.nameNookazon: "cart.fill"
    ]

    var body: some View {
        List(selection: self.$viewModel.selection) {
            Section(header: SectionHeaderView(text: "Drag & Drop to Rearrange",
                                              icon: "arrow.up.arrow.down.circle.fill"),
                    footer: self.footer) {
                ForEach(viewModel.sectionOrder, id: \.name) { section in
                    HStack {
                        Image(systemName: self.iconForSectionName[section.name] ?? "")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(Color("ACSecondaryText"))
                        
                        Text(LocalizedStringKey(self.textForSectionName[section.name] ?? ""))
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

struct TodaySectionEditView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySectionEditView(viewModel: DashboardViewModel())
    }
}
