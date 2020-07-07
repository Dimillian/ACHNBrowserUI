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
    @State private var sheet: Sheet.SheetType?
    @State private var commentsLinkActive = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Group {
                if commentsLinkActive {
                    NavigationLink("",
                                   destination: DodoCodeDetailView(code: code),
                                   isActive: $commentsLinkActive)
                }
                HStack(spacing: 2) {
                    Text(code.archived ? "-----" : code.code.uppercased())
                        .foregroundColor(.acHeaderBackground)
                        .font(.custom("CourierNewPS-BoldMT", size: 20))
                        .lineLimit(1)
                    Image(code.fruit.rawValue.capitalized)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 30, height: 30)
                    code.specialCharacter.map {
                        Image($0.rawValue)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                }
                Text("Hemisphere: \(NSLocalizedString(code.hemisphere.rawValue.capitalized, comment: ""))")
                    .foregroundColor(.acText)
                    .font(.subheadline)
                Text(code.text)
                    .foregroundColor(.acText)
                    .lineLimit(15)
                    .fixedSize(horizontal: false, vertical: true)
                Text(code.creationDate, style: .relative)
                    .foregroundColor(.acSecondaryText)
                    .font(.footnote)
            }.opacity(code.archived ? 0.5 : 1.0)

            if DodoCodeService.shared.canAddCode && showButtons {
                HStack(spacing: 12) {
                    Spacer()
                    upvoteButton
                    if code.isMine {
                        editButton
                        archiveButton
                        if code.archived {
                            deleteButton
                        }
                    } else {
                        reportButton
                    }
                }
            }
        }
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
        .contextMenu { contextMenu }
    }
    
    private var upvoteButton: some View {
        Button(action: {
            if !self.voted {
                self.voted = true
                DodoCodeService.shared.upvote(code: self.code)
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
    
    private var archiveButton: some View {
        Button(action: {
            DodoCodeService.shared.toggleArchive(code: self.code)
        }) {
            ButtonImageCounterOverlay(symbol: code.archived ? "lock" : "lock.open",
                                      foregroundColor: .acSecondaryText,
                                      counter: nil)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
    
    private var editButton: some View {
        Button(action: {
            self.sheet = .dodoCodeForm(editing: self.code)
        }) {
            ButtonImageCounterOverlay(symbol: "square.and.pencil",
                                      foregroundColor: .blue,
                                      counter: nil)
        }
        .buttonStyle(BorderlessButtonStyle())
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
    
    private var contextMenu: some View {
        VStack {
            if code.isMine {
                Button(action: {
                    sheet = .dodoCodeForm(editing: self.code)
                }) {
                    Label("Edit", systemImage: "square.and.pencil")
                }
            }
            Button(action: {
                commentsLinkActive = true
            }) {
                Label("See comments", systemImage: "bubble.right.fill")
            }
        }
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
