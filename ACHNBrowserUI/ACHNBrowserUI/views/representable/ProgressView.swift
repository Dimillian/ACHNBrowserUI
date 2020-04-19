//
//  ProgressView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressView: UIViewRepresentable {
    let progress: Float
    
    func makeUIView(context: Context) -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = UIColor(named: "catalog-unselected")
        view.progressTintColor = UIColor(named: "grass")
        return view
    }
    
    func updateUIView(_ uiView: UIProgressView, context: Context) {
        uiView.progress = progress
    }
}
