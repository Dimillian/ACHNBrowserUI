//
//  Color.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

extension Color {
    
    public static var acBackground: Color {
        Color("ACBackground")
    }
    
    public static var acSecondaryBackground: Color {
        Color("ACSecondaryBackground")
    }
    
    public static var acTertiaryBackground: Color {
        Color("ACTertiaryBackground")
    }
    
    // ---
    
    public static var acHeaderBackground: Color {
        Color("ACHeaderBackground")
    }
    
    public static var acHeaderText: Color {
        Color("ACHeaderText")
    }
    
    // ---
    
    public static var acTabBarBackground: Color {
        Color("ACTabBarBackground")
    }
    
    public static var acTabBarSelected: Color {
        Color("ACTabBarSelected")
    }
    
    public static var acTabBarTint: Color {
        Color("ACTabBarTint")
    }
    
    // ----
    
    public static var acText: Color {
        Color("ACText")
    }
    
    public static var acSecondaryText: Color {
        Color("ACSecondaryText")
    }
    
    // ---
    public static var catalogBackground: Color {
        Color("catalog-background", bundle: nil)
    }
    
    public static var catalogBar: Color {
        Color("catalog-bar", bundle: nil)
    }
    
    public static var catalogSelected: Color {
        Color("catalog-selected", bundle: nil)
    }
    
    public static var catalogUnselected: Color {
        Color("catalog-unselected", bundle: nil)
    }
    
    public static var graphAverage: Color {
        Color("graph-average", bundle: nil)
    }
    
    public static var graphMinMax: Color {
        Color("graph-minmax", bundle: nil)
    }
    
    public static var graphMinimum: Color {
        Color("graph-minimum", bundle: nil)
    }
}
