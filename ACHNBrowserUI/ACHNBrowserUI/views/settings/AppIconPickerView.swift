//
//  AppIconPickerView.swift
//  ACHNBrowserUI
//
//  Created by Matt Bonney on 4/25/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

// Custom icon naming convention is {{ style }}-{{ color }}.
struct AppIcon {
    enum Style: String, CaseIterable {
        case round
        case roundAlt = "round-alt"
        case simple
        case bookmark
    }
    
    enum Color: String, CaseIterable {
        case blue
        case blueberry
        case cactus
        case cocoa
        case gold
        case lime
        case mint
        case orange
        case pink
        case sky
    }
    
    let style: AppIcon.Style
    let color: AppIcon.Color
    var name: String { return "\(self.style.rawValue)-\(self.color.rawValue)" }
}

class AppIconPickerViewModel: ObservableObject {
    static let key = "AppIconPickerViewModelEnabled"
    static let defaultIcon = "round-alt-lime"
    
    @Published var selected: String
    
    var cancellable: AnyCancellable?
    
    init() {
        selected = UserDefaults.standard.string(forKey: Self.key) ?? Self.defaultIcon
        cancellable = $selected
        .receive(on: RunLoop.main)
        .sink {
            UserDefaults.standard.set($0, forKey: Self.key)
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}

struct AppIconPickerView: View {
    @ObservedObject var viewModel = AppIconPickerViewModel()
    
    var body: some View {
        List {
            ForEach(AppIcon.Color.allCases, id: \.self) { color in
                self.makeRow(for: color)
            }
        }
    }
    
    private func makeRow(for color: AppIcon.Color) -> some View {
        HStack {
            ForEach(AppIcon.Style.allCases, id: \.self) { style in
                Image("\(style.rawValue)-\(color.rawValue)")
                    .resizable()
                    .frame(width: 64, height: 64)
                    .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        Group {
                            if AppIcon(style: style, color: color).name == self.viewModel.selected {
                                RoundedRectangle(cornerRadius: 14, style: .continuous)
                                    .stroke(Color.bell, lineWidth: 4)
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        self.setAppIcon(to: AppIcon(style: style, color: color))
                    }
            }
        }
        .padding(.vertical)
    }
    
    private func setAppIcon(to icon: AppIcon) {
        print("@@ Attempting to set icon: \(icon.name)")
        
        self.viewModel.selected = icon.name
        
        UIApplication.shared.setAlternateIconName(icon.name) { (error) in
            if let error = error {
                print("@@ Error setting alternate app icon: \(error)")
                self.viewModel.selected = AppIconPickerViewModel.defaultIcon
            }
        }
    }
}

struct AppIconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconPickerView()
    }
}
