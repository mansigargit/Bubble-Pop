//
//  Direction.swift
//  bubble_pop
//
//  Created by Zhaoqing Liu on 5/5/18.
//  Copyright © 2018 sohoo. All rights reserved.
//

import Foundation
import UIKit

enum Direction: String {
    
    case right = "0"
    case left = "1"
    case up = "2"
    case down = "3"
    case up_right = "4"
    case up_left = "5"
    case down_right = "6"
    case down_left = "7"
    
    
    static func allValues() -> [Direction] {
        return [.right, .left, .up, .down, .up_right, .up_left, .down_right, .down_left]
    }
    
    /*
     * Get a random direction according a identifier of direciton
     */
    static func randomDirection(with id: Int, and is2DMode: Bool) -> CGPoint {
        if !is2DMode {
            return CGPoint(x: -1.0, y: -1.0)
        } else {
            switch id {
            case 0:
                return CGPoint(x: 1.0, y: 0)
            case 1:
                return CGPoint(x: -1.0, y: 0)
            case 2:
                return CGPoint(x: 0, y: -1.0)
            case 3:
                return CGPoint(x: 0, y: 1.0)
            case 4:
                return CGPoint(x: 1.0, y: -1.0)
            case 5:
                return CGPoint(x: -1.0, y: -1.0)
            case 6:
                return CGPoint(x: 1.0, y: 1.0)
            case 7:
                return CGPoint(x: -1.0, y: 1.0)
            default:
                return CGPoint(x: 1.0, y: 1.0)
            }
        }
    }
    
}
