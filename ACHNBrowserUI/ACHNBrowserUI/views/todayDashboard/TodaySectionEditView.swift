//
//  TodaySectionEditView.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodaySectionEditView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var editMode = EditMode.active
    @State private var selection = Set<String>()
    
    @State private var sections: [SectionHeaderView] = [
        SectionHeaderView(text: "New on Nookazon", icon: "cart.fill"),
        SectionHeaderView(text: "Currently Available", icon: "calendar"),
        SectionHeaderView(text: "Collection Progress", icon: "chart.pie.fill"),
        SectionHeaderView(text: "Turnips", icon: "dollarsign.circle.fill"),
        SectionHeaderView(text: "Today's Tasks", icon: "checkmark.seal.fill"),
        SectionHeaderView(text: "Events", icon: "flag.fill"),
        SectionHeaderView(text: "Birthdays", icon: "gift.fill")
    ]
    
    @State private var hiddenSections: [SectionHeaderView] = []
        
    var body: some View {
        List(selection: $selection) {
            
            Section(header: SectionHeaderView(text: "Drag & Drop to Rearrange", icon: "arrow.up.arrow.down.circle.fill"), footer: self.footer) {
                ForEach(sections, id: \.text) { section in
                    HStack {
                        Image(systemName: section.icon ?? "")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 22)
                            .foregroundColor(Color("ACSecondaryText"))
                        
                        Text(section.text)
                            .font(.system(.body, design: .rounded))
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
                .onMove(perform: onMove)
            }
            
            if hiddenSections.count > 0 {
                Section(header: SectionHeaderView(text: "Hidden", icon: "eye.slash.fill")) {
                    ForEach(hiddenSections, id: \.text) { section in
                        HStack {
                            Image(systemName: section.icon ?? "")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(width: 22)
                                .foregroundColor(Color("ACSecondaryText"))
                            
                            Text(section.text)
                                .font(.system(.body, design: .rounded))
                            
                            Spacer()
                        }
                    }
                    .onMove(perform: onMove)
                }
            }
            
        }
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
        .background(RoundedRectangle(cornerRadius: 14, style: .continuous).foregroundColor(Color("ACText").opacity(0.2)))
    }
    
    // @TODO: Do we need explainer text? 
    private var footer: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Drag and drop").fontWeight(.bold) + Text(" to re-order sections. ")
            Text("Check or un-check").fontWeight(.bold) + Text(" rows to hide sections from the dashboard.")
            Text("Your top-most section will be the default detail view on iPad and Mac.")
        }
        .padding(.vertical)
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        sections.move(fromOffsets: source, toOffset: destination)
    }
}

struct TodaySectionEditView_Previews: PreviewProvider {
    static var previews: some View {
        TodaySectionEditView()
    }
}
