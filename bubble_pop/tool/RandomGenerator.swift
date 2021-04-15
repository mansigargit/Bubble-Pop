import Foundation
import GameKit

struct RandomGenerator {
    
    /**
     * Generating random nubmer according to a specified rang, like ==> [1, end]
     */
    static func randomInt(end: Int) -> [Int] {
        var startArr = Array(0...end-1)
        var resultArr = Array(repeating: 0, count: end)
        for i in 0..<startArr.count {
            let currentCount = UInt32(startArr.count - i)
            let index = Int(arc4random_uniform(currentCount))
            resultArr[i] = startArr[index]
            startArr[index] = startArr[Int(currentCount) - 1]
        }
        return resultArr
    }
    
    /**
     *  Generating random number accroding to a semi-closed rang, like ==> (start, end]
     */
    static func randomInt(start: Int, end: Int) -> [Int] {
        let scope = end - start
        var startArr = Array(1...scope)
        var resultArr = Array(repeating: 0, count: scope)
        for i in 0..<startArr.count {
            let currentCount = UInt32(startArr.count - i)
            let index = Int(arc4random_uniform(currentCount))
            resultArr[i] = startArr[index]
            startArr[index] = startArr[Int(currentCount) - 1]
        }
        return resultArr.map { $0 + start }
    }
    
}







