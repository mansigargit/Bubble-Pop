import Foundation
import UIKit

class Positioner {
    
    /*
     * Gengeraing a random array of positions that bubbles should be at
     * layout: dynamic diameter of bubbles according to the size of screen
     * totalCount: the number of bubbles to be created
     *
     */
    static func getAvailablePosition(layout: Layout, totalCount: Int, exceptivePositions: [CGPoint]) -> [CGPoint] {
        
        var positions: [CGPoint] = []
        
        let randomXs: [Int] = RandomGenerator.randomInt(end: layout.countOfHorizentalBubbles)
        let randomYs: [Int] = RandomGenerator.randomInt(end: layout.countOfVerticalBubbles)
        
        for i in 0...totalCount {
            
            let x = CGFloat(Float(randomXs[i%layout.countOfHorizentalBubbles]) * layout.diameterOfBubble + layout.marginLeft)
            let y = CGFloat(Float(randomYs[i%layout.countOfVerticalBubbles]) * layout.diameterOfBubble + layout.marginTop)
            
            var available = true
            for item in exceptivePositions {
                if abs(item.x - x) < CGFloat(layout.diameterOfBubble) && abs(item.y - y) < CGFloat(layout.diameterOfBubble) {
                    available = false
                }
            }
            if available {
                let position: CGPoint = CGPoint(x: x, y: y)
                positions.append(position)
            }
        }
        
        return positions
    }
  
}

