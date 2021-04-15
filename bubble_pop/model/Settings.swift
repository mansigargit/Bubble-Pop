//
//  Settings.swift
//  bubble_pop
//
//  Created by Zhaoqing Liu on 4/5/18.
//  Copyright © 2018 sohoo. All rights reserved.
//

import Foundation
import UIKit

struct Settings {
    
    // The default duration for a game is 60 seconds
    var playTime: TimeInterval = 60
    
    // The default maximum number of bubbles displayed on the screen is 15
    var maxBubbles: Int = 15
    
    // The default moving speed of game is 1 pixel per 0.1 second, which means the difficulty of game is easy
    var movingSpeed: CGPoint = CGPoint(x: -1.0, y: -1.0)
    
    // The default moving direction is 1D, it can also 2D
    var is2DMode: Bool = false
    
    
}
