//
//  IconChooserSheet.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 26/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit

struct IconChooserSheet: View {
    @Environment(\.presentationMode) private var presentation
    
    @Binding var selectedIcon: String?
    
    private let itemSize: CGFloat = 50
    private let iconsCount = 198
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: itemSize))]) {
                    ForEach(0..<iconsCount, id: \.self) { num in
                        let name = "Inv\(num)"
                        Button(action: {
                            selectedIcon = name
                            presentation.wrappedValue.dismiss()
                        }, label: {
                            Image(name)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: itemSize, height: itemSize)
                                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 16)
                                .background(makeSelectedOverlay(name: name))
                        })
    
                    }
                }
            }
            .background(Color.acSecondaryBackground.edgesIgnoringSafeArea(.all))
            .navigationBarTitle("Icons", displayMode: .inline)
            .navigationBarItems(trailing: dismissButton)
        }
    }
    
    @ViewBuilder
    private func makeSelectedOverlay(name: String) -> some View {
        if name == selectedIcon {
            Rectangle()
                .fill(Color.acHeaderBackground)
                .cornerRadius(10)
                .padding()
        } else {
            EmptyView()
        }
    }
    
    private var dismissButton: some View {
        Button(action: {
            presentation.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.red)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.red.opacity(0.2))
    }
}

struct IconChooserSheet_Previews: PreviewProvider {
    static var previews: some View {
        IconChooserSheet(selectedIcon: .constant(""))
    }
}
