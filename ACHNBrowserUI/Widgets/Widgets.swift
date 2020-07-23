//
//  Widgets.swift
//  Widgets
//
//  Created by Thomas Ricouard on 23/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        VillagerBirthdayWidget()
        MuseumProgressWidget()
    }
}
