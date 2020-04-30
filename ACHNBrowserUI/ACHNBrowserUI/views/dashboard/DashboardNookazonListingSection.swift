//
//  DashboardNookazonListingSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 23/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct DashboardNookazonListingSection: View {
    @Binding var selectedSheet: DashboardView.Sheet?
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Recent Nookazon Listings")) {
            if viewModel.recentListings == nil {
                Text("Loading...")
                    .foregroundColor(.secondary)
            }
            viewModel.recentListings.map { listings in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(listings) { listing in
                            Button(action: {
                                self.selectedSheet = .safari(URL.nookazon(listing: listing)!)
                            }) {
                                VStack {
                                    ItemImage(path: listing.img?.absoluteString, size: 80)
                                    Text(listing.name!)
                                        .font(.headline)
                                        .foregroundColor(.text)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.dialogue)
                                        .shadow(radius: 4)
                                )
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                    .padding()
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}

struct DashboardNookazonListingSection_Previews: PreviewProvider {
    static var previews: some View {
        DashboardNookazonListingSection(selectedSheet: .constant(nil),
                                        viewModel: DashboardViewModel())
    }
}
