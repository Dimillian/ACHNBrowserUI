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
    let showButtons: Bool
        
    @State private var voted = false
    @State private var reported = false
    @State private var showDeleteAlert = false
    @State private var showReportAlert = false
    
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
            Text("Hemisphere: \(NSLocalizedString(code.hemisphere.rawValue.capitalized, comment: ""))")
                .foregroundColor(.acText)
                .font(.subheadline)
            Text(code.text)
                .foregroundColor(.acText)
                .lineLimit(15)
            Text(formatter.string(from: code.creationDate))
                .foregroundColor(.acText)
                .font(.footnote)

            if DodoCodeService.shared.canEdit && showButtons {
                HStack {
                    Spacer()
                    upvoteButton
                    reportButton
                    if code.canDelete {
                        deleteButton
                    }
                }
            }
        }
    }
    
    private var upvoteButton: some View {
        Button(action: {
            if !self.voted {
                self.voted = true
                DodoCodeService.shared.upvote(code: self.code)
                FeedbackGenerator.shared.triggerSelection()
            }
        }) {
            Image(systemName: voted ? "hand.thumbsup.fill" : "hand.thumbsup")
                .imageScale(.medium)
                .font(.footnote)
                .foregroundColor(.green)
                .padding(.vertical, 7)
                .padding(.horizontal, 8)
                .background(Color.acBackground)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(counter(count: code.upvotes), alignment: .topTrailing)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(.trailing, 4)
    }
    
    private var reportButton: some View {
        Button(action: {
            self.showReportAlert = true
        }) {
            Group {
                if reported {
                    ActivityIndicator(isAnimating: .constant(true),
                                      style: .medium)
                } else {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.acSecondaryText)
                        .font(.footnote)
                        .padding(.vertical, 7)
                        .padding(.horizontal, 8)
                        .background(Color.acBackground)
                        .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .overlay(counter(count: code.report), alignment: .topTrailing)
                }
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $showReportAlert) {
            reportAlert
        }
        .padding(.trailing, 4)
    }
    
    private var deleteButton: some View {
        Button(action: {
            self.showDeleteAlert = true
        }) {
            Image(systemName: "trash.fill")
                .imageScale(.medium)
                .font(.footnote)
                .foregroundColor(.red)
                .padding(.vertical, 7)
                .padding(.horizontal, 8)
                .background(Color.acBackground)
                .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
        .buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $showDeleteAlert) {
            deleteAlert
        }
    }
    
    private var deleteAlert: Alert {
        Alert(title: Text("Are you sure?"),
              message: Text("Do you really want to delete your Dodo code?"), primaryButton: .destructive(Text("Delete")) {
                      DodoCodeService.shared.delete(code: self.code)
              }, secondaryButton: .cancel())
    }
    
    private var reportAlert: Alert {
        Alert(title: Text("Are you sure?"),
              message: Text("Do you really want to report this Dodo code?"), primaryButton: .destructive(Text("Report")) {
                      self.reported = true
                      DodoCodeService.shared.report(code: self.code)
              }, secondaryButton: .cancel())
    }
    
    private func counter(count: Int) -> some View {
        ZStack {
            Circle()
                .scale(2)
                .fixedSize()
                .foregroundColor(Color.acBackground)
            Text("\(count)")
                .font(.footnote)
                .foregroundColor(.acText)
        }
        .opacity(count > 0 ? 1 : 0)
        .animation(.linear)
        .padding(EdgeInsets(top: -5, leading: 0, bottom: 0, trailing: -6))
    }
}

struct DodoCodeRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DodoCodeRow(code: static_dodoCode, showButtons: true)
            }
        }
    }
}
