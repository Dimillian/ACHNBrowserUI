//
//  TodayNookazonSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import UI

struct TodayNookazonSection: View {
    @Binding var sheet: Sheet.SheetType?
    @ObservedObject var viewModel: DashboardViewModel
    
    var body: some View {
        Section(header: SectionHeaderView(text: "New on Nookazon", icon: "cart.fill")) {
            if viewModel.recentListings?.isEmpty == false {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(viewModel.recentListings!) { listing in
                            HStack {
                                VStack {
                                    ItemImage(path: listing.img?.absoluteString, size: 66)
                                    Text("\(listing.name!)")
                                        .font(.system(.subheadline, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(.acText)
                                        .padding(.bottom, 4)
                                }
                                .padding(.horizontal)
                                .onTapGesture {
                                    //self.sheet = .safari(URL.nookazon(listing: listing)!)
                                    UIApplication.shared.open(URL.nookazon(listing: listing)!,
                                                               options: [:],
                                                               completionHandler: nil)
                                }
                                
                                Divider()
                            }
                        }
                    }
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
    }
}


struct TodayNookazonSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TodayNookazonSection(sheet: .constant(nil),
                                 viewModel: DashboardViewModel())
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}
