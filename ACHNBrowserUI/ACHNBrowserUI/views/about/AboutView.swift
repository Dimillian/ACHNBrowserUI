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
    
    private func makeRow(image: String,
                         text: LocalizedStringKey,
                         link: URL? = nil,
                         color: Color) -> some View {
        HStack {
            Image(systemName: image)
                .imageScale(.medium)
                .foregroundColor(color)
                .frame(width: 30)
            Group {
                if let link = link {
                    Link(text, destination: link)
                } else {
                    Text(text)
                }
            }
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
                    Group {
                        makeRow(image: "chevron.left.slash.chevron.right",
                                text: "Source code / report an issue",
                                link: URL(string: "https://github.com/Dimillian/ACHNBrowserUI"),
                                color: .acHeaderBackground)
                        makeRow(image: "envelope.fill",
                                text: "Contact / follow us on Twitter",
                                link: URL(string: "https://twitter.com/achelperapp"),
                                color: .acHeaderBackground)
                        makeRow(image: "photo.fill",
                                text: "Contact / follow us on Instagram",
                                link: URL(string: "https://www.instagram.com/achelperapp/"),
                                color: .acHeaderBackground)
                        makeRow(image: "star.fill",
                                text: "Rate the app on the App Store",
                                link: URL(string: "itms-apps://itunes.apple.com/app/1508764244?action=write-review"),
                                color: .acHeaderBackground)
                        makeRow(image: "lock",
                                text: "Privacy Policy",
                                link: URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/main/privacy-policy.md#ac-helper-privacy-policy"),
                                color: .acHeaderBackground)
                        makeRow(image: "person",
                                text: "Terms of Use",
                                link: URL(string: "https://github.com/Dimillian/ACHNBrowserUI/blob/main/term-of-use.md#ac-helper-term-of-use"),
                                color: .acHeaderBackground)
                        makeDetailRow(image: "tag",
                                      text: "App version",
                                      detail: "\(versionNumber) (\(buildNumber))",
                                      color: .acHeaderBackground)
                        makeDetailRow(image: "gamecontroller",
                                      text: "Game patch data",
                                      detail: "1.6.0",
                                      color: .acHeaderBackground)
                    }.listRowBackground(Color.acSecondaryBackground)
                }

                Section(header: SectionHeaderView(text: "Acknowledgements")) {
                    Group {
                        makeRow(image: "suit.heart.fill",
                                text: "Our amazing contributors",
                                link: URL(string: "https://github.com/Dimillian/ACHNBrowserUI/graphs/contributors"),
                                color: .red)
                        makeRow(image: "suit.heart.fill",
                                text: "The NookPlaza API by Azarro",
                                link: URL(string: "https://nookplaza.net/"),
                                color: .red)
                        makeRow(image: "suit.heart.fill",
                                text: "The ACNHAPI for villagers data and images",
                                link: URL(string: "http://acnhapi.com"),
                                color: .red)
                        makeRow(image: "suit.heart.fill",
                                text: "Meet the community of ACNH Connect",
                                link: URL(string: "https://apps.apple.com/us/app/acnh-connect/id1511183931"),
                                color: .red)
                        makeRow(image: "suit.heart.fill",
                                text: "Shihab / JPEGuin for the icon",
                                link: URL(string: "https://twitter.com/JPEGuin"),
                                color: .red)
                        makeRow(image: "suit.heart.fill",
                                text: "Christian & Ninji for the turnip predictions algorithm",
                                link: URL(string: "https://elxris.github.io/Turnip-Calculator/"),
                                color: .red)
                    }.listRowBackground(Color.acSecondaryBackground)
                }
            }
            .listStyle(InsetGroupedListStyle())
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
