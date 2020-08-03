//
//  DreamCodeRow.swift
//  ACHNBrowserUI
//
//  Created by Jan van Heesch on 02.08.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct DreamCodeRow: View {
    let code: DreamCode
    let showButtons: Bool
        
    @State private var voted = false
    @State private var reported = false
    @State private var showDeleteAlert = false
    @State private var showReportAlert = false
    @State private var sheet: Sheet.SheetType?
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                HStack(spacing: 2) {
                    Text(code.code.uppercased())
                        .foregroundColor(.dreamCode)
                        .font(.custom("CourierNewPS-BoldMT", size: 20))
                        .lineLimit(1)
                }
                Text("Hemisphere: \(NSLocalizedString(code.hemisphere.rawValue.capitalized, comment: ""))")
                    .foregroundColor(.acText)
                    .font(.subheadline)
                Text(code.text)
                    .foregroundColor(.acText)
                    .lineLimit(15)
                    .fixedSize(horizontal: false, vertical: true)
                Text(formatter.string(from: code.creationDate))
                    .foregroundColor(.acText)
                    .font(.footnote)
            }

            if DreamCodeService.shared.canAddCode && showButtons {
                HStack(spacing: 12) {
                    Spacer()
                    upvoteButton
                    if code.isMine {
                        editButton
                        deleteButton
                    } else {
                        reportButton
                    }
                }
            }
        }
    }
    
    private var upvoteButton: some View {
        Button(action: {
            if !self.voted {
                self.voted = true
                DreamCodeService.shared.upvote(code: self.code)
                FeedbackGenerator.shared.triggerSelection()
            }
        }) {
            ButtonImageCounterOverlay(symbol: voted ? "hand.thumbsup.fill" : "hand.thumbsup",
                               foregroundColor: .green,
                               counter: code.upvotes)
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
                    ProgressView()
                } else {
                    ButtonImageCounterOverlay(symbol: "exclamationmark.triangle.fill",
                                       foregroundColor: .acSecondaryText,
                                       counter: code.report)
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
            ButtonImageCounterOverlay(symbol: "trash.fill",
                               foregroundColor: .red,
                               counter: nil)
        }
        .buttonStyle(BorderlessButtonStyle())
        .alert(isPresented: $showDeleteAlert) {
            deleteAlert
        }
    }
    
    private var editButton: some View {
        Button(action: {
            self.sheet = .dreamCodeForm(editing: self.code)
        }) {
            ButtonImageCounterOverlay(symbol: "square.and.pencil",
                                      foregroundColor: .blue,
                                      counter: nil)
        }
        .buttonStyle(BorderlessButtonStyle())
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
    }
    
    private var deleteAlert: Alert {
        Alert(title: Text("Are you sure?"),
              message: Text("Do you really want to delete your dream code?"), primaryButton: .destructive(Text("Delete")) {
                      DreamCodeService.shared.delete(code: self.code)
              }, secondaryButton: .cancel())
    }
        
    private var reportAlert: Alert {
        Alert(title: Text("Are you sure?"),
              message: Text("Do you really want to report this dream code?"), primaryButton: .destructive(Text("Report")) {
                      self.reported = true
                      DreamCodeService.shared.report(code: self.code)
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

struct DreamCodeRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DreamCodeRow(code: static_dreamCode, showButtons: true)
            }
        }
    }
}

