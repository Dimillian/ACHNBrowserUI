//
//  AboutView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 30/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import UI

struct AboutView: View {
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedSheet: Sheet.SheetType?
    
    private var versionNumber: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? NSLocalizedString("Error", comment: "")
    }
    
    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? NSLocalizedString("Error", comment: "")
    }
    
    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Dismiss")
        })
        .safeHoverEffectBarItem(position: .leading)
    }
    
    private func makeRow(image: String, text: String, color: Color) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(color)
                .frame(width: 30)
            Text(text)
                .foregroundColor(.text)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right").imageScale(.medium)
        }
    }
    
    private func makeDetailRow(image: String, text: String, detail: String, color: Color) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(color)
                .frame(width: 30)
            Text(text)
                .foregroundColor(.text)
                .font(.body)
            Spacer()
            Text(detail)
                .foregroundColor(.gray)
                .font(.callout)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeaderView(text: NSLocalizedString("The app", comment: ""))) {
                    makeRow(image: "chevron.left.slash.chevron.right",
                            text: NSLocalizedString("Souce code / report an issue", comment: ""), color: .bell)
                        .onTapGesture {
                                self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI")!)
                    }
                    makeRow(image: "star.fill",
                            text: NSLocalizedString("Rate the app on the App Store", comment: ""), color: .bell)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id1508764244")!,
                                                      options: [:],
                                                      completionHandler: nil)
                    }
                    makeRow(image: "lock", text: NSLocalizedString("Privacy Policy", comment: ""), color: .bell).onTapGesture {
                        self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/privacy-policy.md#ac-helper-privacy-policy")!)
                    }
                    makeRow(image: "person", text: NSLocalizedString("Term of Use", comment: ""), color: .bell).onTapGesture {
                        self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/term-of-use.md#ac-helper-term-of-use")!)
                    }
                    makeDetailRow(image: "tag",
                                  text: NSLocalizedString("App version", comment: ""),
                                  detail: "\(versionNumber) (\(buildNumber))",
                                  color: .bell)
                    makeDetailRow(image: "gamecontroller",
                                  text: NSLocalizedString("Game patch data", comment: ""),
                                  detail: "1.2.0",
                                  color: .bell)
                }
                Section(header: SectionHeaderView(text: NSLocalizedString("Acknowledgements", comment: ""))) {
                    makeRow(image: "suit.heart.fill", text: NSLocalizedString("Our amazing contributors", comment: ""), color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI/graphs/contributors")!)
                    }
                    makeRow(image: "suit.heart.fill", text: NSLocalizedString("The NookPlaza API by Azarro", comment: ""), color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://nookplaza.net/")!)
                    }
                    makeRow(image: "suit.heart.fill", text: NSLocalizedString("Turnip.exchange", comment: ""), color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://turnip.exchange/")!)
                    }
                    makeRow(image: "suit.heart.fill", text: NSLocalizedString("Nookazon for the marketplace", comment: ""), color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://nookazon.com/")!)
                    }
                    makeRow(image: "suit.heart.fill", text: NSLocalizedString("Shihab / JPEGuin for the icon", comment: ""), color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://twitter.com/JPEGuin")!)
                    }
                    makeRow(image: "suit.heart.fill",
                            text: NSLocalizedString("Christian & Ninji for the turnip predictions algorithm", comment: ""),
                            color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://elxris.github.io/Turnip-Calculator/")!)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("About"), displayMode: .inline)
            .navigationBarItems(leading: dismissButton)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $selectedSheet, content: {
            Sheet(sheetType: $0)
        })
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
