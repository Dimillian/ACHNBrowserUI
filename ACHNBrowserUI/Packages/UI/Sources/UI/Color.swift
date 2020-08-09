//
//  Color.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public let UIBundle = Bundle.module

extension Color {
    
    public static var acBackground: Color {
        Color("ACBackground", bundle: Bundle.module)
    }
    
    public static var acDynamicForeground: Color {
        Color("ACDynamicForeground", bundle: Bundle.module)
    }
    
    public static var acSecondaryBackground: Color {
        Color("ACSecondaryBackground", bundle: Bundle.module)
    }
    
    public static var acTertiaryBackground: Color {
        Color("ACTertiaryBackground", bundle: Bundle.module)
    }
    
    // ---
    
    public static var acHeaderBackground: Color {
        Color("ACHeaderBackground", bundle: Bundle.module)
    }
    
    public static var acHeaderText: Color {
        Color("ACHeaderText", bundle: Bundle.module)
    }
    
    // ---
    
    public static var acTabBarBackground: Color {
        Color("ACTabBarBackground", bundle: Bundle.module)
    }
    
    public static var acTabBarSelected: Color {
        Color("ACTabBarSelected", bundle: Bundle.module)
    }
    
    public static var acTabBarTint: Color {
        Color("ACTabBarTint", bundle: Bundle.module)
    }
    
    // ----
    
    public static var acText: Color {
        Color("ACText", bundle: Bundle.module)
    }
    
    public static var acSecondaryText: Color {
        Color("ACSecondaryText", bundle: Bundle.module)
    }
    
    public static var acBlueText: Color {
        Color("ACBlueText", bundle: Bundle.module)
    }
    
    // ---
    public static var catalogBackground: Color {
        Color("catalog-background", bundle: Bundle.module)
    }
    
    public static var catalogBar: Color {
        Color("catalog-bar", bundle: Bundle.module)
    }
    
    public static var catalogSelected: Color {
        Color("catalog-selected", bundle: Bundle.module)
    }
    
    public static var catalogUnselected: Color {
        Color("catalog-unselected", bundle: Bundle.module)
    }
    
    public static var graphAverage: Color {
        Color("graph-average", bundle: Bundle.module)
    }
    
    public static var graphMinMax: Color {
        Color("graph-minmax", bundle: Bundle.module)
    }
    
    public static var graphMinimum: Color {
        Color("graph-minimum", bundle: Bundle.module)
    }
    
    // ---
    public static var dreamCode : Color {
        Color("DreamCode", bundle: Bundle.module)
    }
}
