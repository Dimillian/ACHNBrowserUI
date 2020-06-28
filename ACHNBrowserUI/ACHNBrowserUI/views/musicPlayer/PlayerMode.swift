//
//  PlayerMode.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 28/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

enum PlayerMode {
    case playerSmall, playerExpanded, playerMusicList
    
    func coverSize() -> CGFloat {
        switch self {
        case .playerSmall, .playerMusicList:
            return 40
        case .playerExpanded:
            return 200
        }
    }
    
    func height() -> CGFloat {
        switch self {
        case .playerSmall:
            return 50
        case .playerExpanded, .playerMusicList:
            return 500
        }
    }
    
    func isExpanded() -> Bool {
        switch self {
        case .playerSmall:
            return false
        case .playerExpanded, .playerMusicList:
            return true
        }
    }
    
    mutating func toggleExpanded() {
            switch self {
            case .playerSmall:
                self = .playerExpanded
            case .playerExpanded:
                self = .playerSmall
            case .playerMusicList:
                self = .playerSmall
            }
    }
}
    
