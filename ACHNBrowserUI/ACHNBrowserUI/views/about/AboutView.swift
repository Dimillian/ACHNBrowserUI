//
//  AboutView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 30/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct AboutView: View {
    private enum Sheet: Identifiable {
        case safari(URL)
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            }
        }
    }
    
    @Environment(\.presentationMode) private var presentationMode
    @State private var selectedSheet: Sheet?
    
    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Dismiss")
        })
    }
    
    private func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .safari(let url):
            return AnyView(SafariView(url: url))
        }
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
    
    var body: some View {
        NavigationView {
            List {
                Section(header: SectionHeaderView(text: "The app")) {
                    makeRow(image: "chevron.left.slash.chevron.right",
                            text: "Souce code / report an issue", color: .bell)
                        .onTapGesture {
                                self.selectedSheet = .safari(URL(string: "https://github.com/Dimillian/ACHNBrowserUI")!)
                    }
                    makeRow(image: "star.fill",
                            text: "Rate the app on the App Store", color: .bell)
                        .onTapGesture {
                            UIApplication.shared.open(URL(string: "https://itunes.apple.com/app/id1508764244")!,
                                                      options: [:],
                                                      completionHandler: nil)
                    }
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
                            text: "Christian & Ninji for the turnips predictions algorithm",
                            color: .red)
                        .onTapGesture {
                            self.selectedSheet = .safari(URL(string: "https://elxris.github.io/Turnip-Calculator/")!)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("About"), displayMode: .inline)
            .navigationBarItems(leading: dismissButton)
        }.sheet(item: $selectedSheet, content: makeSheet)
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
