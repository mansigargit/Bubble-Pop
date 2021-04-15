import Foundation
import UIKit

enum BubbleImager:  String {
    //set the image of corresponding color according a color
    case red = "bubble-red.png"
    case magenta = "bubble-magenta.png"
    case green = "bubble-green.png"
    case blue = "bubble-blue.png"
    case black = "bubble-black.png"
    
    
    static func allValues() -> [BubbleImager] {
        return [.red, .magenta, .green, .blue, .black]
    }
    
    /*
     * Get a path of image of corresponding color according a color
     */
    static func imagePath(color: UIColor) -> String {
	 /*
     * return value of image
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
            return ""
        }
    }
    
}
