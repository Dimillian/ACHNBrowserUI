//
//  DodoCodeRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 12/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct DodoCodeRow: View {
    let code: DodoCode
    
    @State private var reported = false
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 2) {
                Image(code.fruit.rawValue.capitalized)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(code.code.uppercased())
                    .foregroundColor(.acHeaderBackground)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
            }
            Text(String.init(format: NSLocalizedString("Hemisphere: %@", comment: ""),
                             NSLocalizedString(code.hemisphere.rawValue.capitalized, comment: "")))
                .foregroundColor(.acText)
                .font(.subheadline)
            Text(code.text)
                .foregroundColor(.acText)
                .lineLimit(15)
            Text(formatter.string(from: code.creationDate))
                .foregroundColor(.acText)
                .font(.footnote)
            if DodoCodeService.shared.canEdit {
                HStack {
                    Button(action: {
                        self.reported = true
                        DodoCodeService.shared.reportDodocode(code: self.code)
                    }) {
                        Group {
                            if reported {
                                ActivityIndicator(isAnimating: .constant(true),
                                                  style: .medium)
                            } else {
                                Text(String.init(format: NSLocalizedString("Report (%lld)", comment: ""),
                                                 code.report))
                                    .foregroundColor(.acSecondaryText)
                            }
                        }
                    }.buttonStyle(BorderlessButtonStyle())
                    if code.canDelete {
                        Button(action: {
                            DodoCodeService.shared.deleteDodoCode(code: self.code)
                        }) {
                            Text("Delete").foregroundColor(.red)
                        }.buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
    }
}

struct DodoCodeRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DodoCodeRow(code: static_dodoCode)
            }
        }
    }
}
