import Foundation
import UIKit

enum BubblePointor: Int {
     /*
     * Get a point according a color
     */
    case red = 1
    case magenta = 2
    case green = 5
    case blue = 8
    case black = 10
    
    
    static func allValues() -> [BubbleImager] {
        return [.red, .magenta, .green, .blue, .black]
    }
    
    /*
     * Get a point according a color
     */
    static func points(color: UIColor) -> Int {
	/* 
	*return the value
	*/
        switch color {
        case .red:
            return self.red.rawValue
        case .magenta:
            return self.magenta.rawValue
        case .green:
            return self.green.rawValue
        case .blue:
            return self.blue.rawValue
        case .black:
            return self.black.rawValue
        default:
            return 0
        }
    }
    
}
