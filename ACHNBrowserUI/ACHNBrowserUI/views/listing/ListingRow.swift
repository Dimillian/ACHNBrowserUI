//
//  ListingRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ListingRow: View {
    let listing: Listing
    var hideDetail: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 4) {
                listing.prices?.first {
                    $0.name == nil
                    }?.bells.map { bells in
                        Group {
                            Image("icon-bells")
                                .renderingMode(.original)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                            Text("\(bells)")
                        }
                }
            }
            ForEach(listing.prices?.filter {
                $0.bells == nil
                } ?? [], id: \.name) { item in
                    item.name.map { name in
                        HStack(spacing: 4) {
                            item.img.map {
                                ItemImage(path: $0.absoluteString,
                                          size: 25)
                            }
                            Text(name)
                        }
                    }
            }
            if listing.makeOffer == true {
                HStack(spacing: 4) {
                    Image("icon-bell")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Make an Offer")
                }
            }
            if listing.needMaterials == true {
                HStack(spacing: 4) {
                    Image("icon-helmet")
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                    Text("Need Materials")
                }
            }
            if !hideDetail {
                Text("\(listing.username)\(listing.discord.map { $0.isEmpty ? "" : " · \($0)" } ?? "")\(listing.rating.map { $0.isEmpty ? " · No Rating" : " · \($0[..<$0.index($0.startIndex, offsetBy: 4)]) Rating" } ?? " · No Rating")")
                    .font(.subheadline)
                    .foregroundColor(.acSecondaryText)
            }
        }
        .font(.headline)
        .foregroundColor(.acText)
    }
}
