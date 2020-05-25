//
//  AboutView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 30/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
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
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        })
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffectBarItem(position: .leading)
    }
    
    private func makeRow(image: String, text: LocalizedStringKey, color: Color) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(color)
                .frame(width: 30)
            Text(text)
                .foregroundColor(.acText)
                .font(.body)
            Spacer()
            Image(systemName: "chevron.right").imageScale(.medium)
        }
    }
    
    private func makeDetailRow(image: String, text: LocalizedStringKey, detail: String, color: Color) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(color)
                .frame(width: 30)
            Text(text)
                .foregroundColor(.acText)
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
                Section(header: SectionHeaderView(text: "The app")) {
                    makeRow(image: "chevron.left.slash.chevron.right",
                            text: "Souce code / report an issue", color: .acHeaderBackground)
                        .onTapGesture {
                                self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI")!)
                    }
                    makeRow(image: "star.fill",
                            text: "Rate the app on the App Store", color: .acHeaderBackground)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/1508764244?action=write-review")!,
                                                      options: [:],
                                                      completionHandler: nil)
                    }
                    makeRow(image: "lock", text: "Privacy Policy", color: .acHeaderBackground).onTapGesture {
                        self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/privacy-policy.md#ac-helper-privacy-policy")!)
                    }
                    makeRow(image: "person", text: "Terms of Use", color: .acHeaderBackground).onTapGesture {
                        self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/master/term-of-use.md#ac-helper-term-of-use")!)
                    }
                    makeDetailRow(image: "tag",
                                  text: "App version",
                                  detail: "\(versionNumber) (\(buildNumber))",
                                  color: .acHeaderBackground)
                    makeDetailRow(image: "gamecontroller",
                                  text: "Game patch data",
                                  detail: "1.2.1",
                                  color: .acHeaderBackground)
                }
                Section(header: SectionHeaderView(text: "Acknowledgements")) {
                    makeRow(image: "suit.heart.fill", text: "Our amazing contributors", color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI/graphs/contributors")!)
                    }
                    makeRow(image: "suit.heart.fill", text: "The NookPlaza API by Azarro", color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://nookplaza.net/")!)
                    }
                    makeRow(image: "suit.heart.fill", text: "The ACNHAPI for villagers data and images",
                            color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "http://acnhapi.com")!)
                    }
                    makeRow(image: "suit.heart.fill", text: "Turnip.exchange", color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://turnip.exchange/")!)
                    }
                    makeRow(image: "suit.heart.fill", text: "Nookazon for the marketplace", color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://nookazon.com/")!)
                    }
                    makeRow(image: "suit.heart.fill", text: "Shihab / JPEGuin for the icon", color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://twitter.com/JPEGuin")!)
                    }
                    makeRow(image: "suit.heart.fill",
                            text: "Christian & Ninji for the turnip predictions algorithm",
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
