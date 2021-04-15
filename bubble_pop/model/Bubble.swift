//
//  BubbleType.swift
//  BubblePop
//
//  Created by Zhaoqing Liu on 30/4/18.
//  Copyright © 2018 sohoo. All rights reserved.
//

import UIKit
import GameKit

class Bubble {
    
    // Being used to store the color of a random bubble
    var color: UIColor
    
    // Being used to store the point when a bubble is tapped
    let points: Int
    
    init(color: UIColor, points: Int) {
        self.color = color
        self.points = points
    }
    
    /*
     * Creating a bubble with a random color according the probability for appearance of differenct color
     */
    static func random() -> Bubble {
        let randomBubbleColor = createRandomBubbleColor()
        let points = BubblePointor.points(color: randomBubbleColor)
        return Bubble(color: randomBubbleColor, points: points)
    }
    
    /*
     * Creating random a color for a bubble according the probability for appearance of differenct color bubbles
     * Probability of appearance of different color bubbles
     *      Red                 40%
     *      Pink (magenta)      30%
     *      Green               15%
     *      Blue                10%
     *      Black               5%
     */
    static func createRandomBubbleColor() -> UIColor {
        let randomSource: GKRandomSource = GKARC4RandomSource()
        var box: Array<UIColor> = []
        
        for _ in 1...40 {
            box.append(.red)
        }
        for _ in 1...30 {
            box.append(.magenta)
        }
        for _ in 1...15 {
            box.append(.green)
        }
        for _ in 1...10 {
            box.append(.blue)
        }
        for _ in 1...5 {
            box.append(.black)
        }
        
        let randomNumber: Int = randomSource.nextInt(upperBound: box.count)
        return box[randomNumber]
    }

}
