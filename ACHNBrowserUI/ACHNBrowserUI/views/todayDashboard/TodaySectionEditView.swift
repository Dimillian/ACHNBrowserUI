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

    var body: some View {
        List(selection: self.$viewModel.selection) {
            Section(header: SectionHeaderView(text: "Drag & Drop to Rearrange",
                                              icon: "arrow.up.arrow.down.circle.fill"),
                    footer: self.footer) {
                        ForEach(viewModel.sectionOrder, content: makeRow)
                            .onMove(perform: onMove)
            }
        }
        .listStyle(InsetGroupedListStyle())
        .accentColor(.acHeaderBackground)
        .environment(\.editMode, .constant(.active))
        .navigationBarTitle("Today Sections")
        .onDisappear(perform: self.viewModel.saveSectionList)
    }
    
    private func makeRow(section: TodaySection) -> some View {
        HStack {
            Image(systemName: section.iconName)
                .imageScale(.medium)
                .font(.system(.subheadline, design: .rounded))
                .frame(width: 22)
                .foregroundColor(.acSecondaryText)
            
            Text(LocalizedStringKey(section.sectionName))
                .font(.system(.body, design: .rounded))
            
            Spacer()
        }
    }
    
    private var footer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drag and drop").fontWeight(.bold) + Text(" to re-order sections.")
            Text("Check or un-check").fontWeight(.bold) + Text(" rows to hide sections from the dashboard.")
            Spacer()
            Text("Reset")
            .underline()
            .onTapGesture {
                self.viewModel.resetSectionList()
                FeedbackGenerator.shared.triggerSelection()
            }
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
