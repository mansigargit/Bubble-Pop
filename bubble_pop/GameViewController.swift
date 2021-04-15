import UIKit

import GameplayKit

class GameViewController: UIViewController {
    
    // Being used to store a player's name
    var playerName: String?
    
    // Being used to store the settings of the game
    var settings: Settings?
    
    // Being used to accessing resources
    let bundle = Bundle.main
    
    // Being used as a random number generator
    let randomSource: GKRandomSource = GKARC4RandomSource()
    
    // Being used for timing
    var timerUpdater: Timer?
    var timerMover: Timer?
    
    
    // Being used to store the layout configuration of bubbles
    var layout: Layout?
    
    // Being used to store the remaining time of a game
    var remainingTime: Int?
    
    // Being used to store the score of a game
    var score: Int = 0
    
    lazy var highestScore: Int = {
        let filePath = self.bundle.path(forResource: "ranking", ofType: ".plist")
        let loadedRankingList: Array<Dictionary<String, String>> = NSArray.init(contentsOfFile: filePath!) as! Array<Dictionary<String, String>>
        return Int(loadedRankingList[0]["highestScore"]!)!
    }()
    
    @IBOutlet weak var lblRemainingTime: UILabel!
    
    @IBOutlet weak var lblScore: UILabel!
    
    @IBOutlet weak var lblHighestScore: UILabel!
    
    @IBOutlet weak var viewBoard: UIView!
    
    @IBOutlet weak var btnLatestTappedBubble: BubbleButton!
    
    @IBOutlet weak var viewCountDown1: UIView!
    @IBOutlet weak var lblCountDown1: UILabel!
    @IBOutlet weak var viewCountDown2: UIView!
    @IBOutlet weak var lblCountDown2: UILabel!
    @IBOutlet weak var viewCountDown3: UIView!
    @IBOutlet weak var lblCountDown3: UILabel!
    
    @IBOutlet weak var imgBackground: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adapt to the screen
        self.viewBoard.frame.size.width = self.view.bounds.width
        self.viewCountDown1.frame.size.width = self.view.bounds.width
        self.viewCountDown1.frame.size.height = self.view.bounds.height - self.viewBoard.bounds.height
        self.imgBackground.frame.size.width = self.view.bounds.width
        self.imgBackground.frame.size.height = self.view.bounds.height - self.viewBoard.bounds.height
        
        if self.settings == nil {
            self.settings = Settings()
        }
        
        self.initUI()
        self.initailizeBubbles()
        
        self.navigationItem.hidesBackButton = true
        self.view.backgroundColor = UIColor.white
        
    }
    
    /*
     * Initializing the timer before the main view is displayed
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // MARK: - Execute the countdown animation, then start all timers
        self.disableAllBubbles()
        self.countdown()
        self.perform(#selector(enableAllBubbles), with: nil, afterDelay: 3)
        
        self.perform(#selector(startTimer), with: nil, afterDelay: 4)
        
    }
    
    /*
     * Execute the countdown animation before starting a game
     */
    func countdown()  {
        
        viewCountDown1.isHidden = false
        viewCountDown2.isHidden = false
        viewCountDown3.isHidden = false
        var views: [UIView] = [viewCountDown3, viewCountDown2, viewCountDown1]
        var lbls: [UILabel] = [lblCountDown3, lblCountDown2, lblCountDown1]
        for i in 0..<views.count {
            UIView.animate(withDuration: 1, delay: TimeInterval(i), options: [], animations: {
                lbls[i].layer.setAffineTransform(CGAffineTransform(scaleX: 5, y: 5))
            }) { (true) in
                lbls[i].layer.setAffineTransform(CGAffineTransform.identity)
                views[i].isHidden = true
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        timerUpdater?.invalidate()
        timerUpdater = nil
        timerMover?.invalidate()
        timerMover = nil
    }
    
    /*
     * Starting the timer
     */
    @IBAction func startTimer() {
        // Start the timer for updating the number of bubbles per second
        if timerUpdater == nil {
            timerUpdater = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateUI), userInfo: nil, repeats: true)
        }
        
        // Start the timer for moving the bubbles every 0.01 second
        if timerMover == nil {
            timerMover = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer: Timer) in
                self.updateMovement()
            })
        }
    }
    
    /*
     * Move all the current bubbles on the screen every o.1 second
     */
    func updateMovement() {
        
        for item in self.view.subviews {
            if item is BubbleButton {
                
                if !(self.settings?.is2DMode)! {
                    // MARK: - Judge one-direction movement
                    (item as! BubbleButton).movingSpeed.y -= 0.01
                    item.center = CGPoint(x: item.center.x, y: item.center.y + (item as! BubbleButton).movingSpeed.y)
                    
                    // Judge if there is any bubble will be intersected in by this this bubble next duration
                    for item2 in self.view.subviews {
                        if item2 is BubbleButton {
                            if item.center.x == item2.center.x && item.frame.intersects(item2.frame) {
                                (item2 as! BubbleButton).movingSpeed.y = (item as! BubbleButton).movingSpeed.y
                            }
                        }
                    }
                } else {
                    // MARK: - Pattern two: Judge 2D movement
                    (item as! BubbleButton).movingSpeed.x -= 0.01
                    (item as! BubbleButton).movingSpeed.y -= 0.01
                    item.center = CGPoint(x: item.center.x + (item as! BubbleButton).movingSpeed.x, y: item.center.y + (item as! BubbleButton).movingSpeed.y)
                    
                    if item.frame.minY <= self.viewBoard.bounds.height + abs((item as! BubbleButton).movingSpeed.y) {
                        (item as! BubbleButton).movingSpeed.y = abs((item as! BubbleButton).movingSpeed.y)
                    }
                    if item.frame.maxY >= self.view.frame.height - abs((item as! BubbleButton).movingSpeed.y) {
                        (item as! BubbleButton).movingSpeed.y = -abs((item as! BubbleButton).movingSpeed.y)
                    }
                    if item.frame.minX <= abs((item as! BubbleButton).movingSpeed.x) {
                        (item as! BubbleButton).movingSpeed.x = abs((item as! BubbleButton).movingSpeed.x)
                    }
                    if item.frame.maxX >= self.view.frame.width - abs((item as! BubbleButton).movingSpeed.x) {
                        (item as! BubbleButton).movingSpeed.x = -abs((item as! BubbleButton).movingSpeed.x)
                    }
                    
                    // Judge if there is any bubble will be intersected in by this this bubble next duration
                    for item2 in self.view.subviews {
                        if item2 is BubbleButton {
                            if item.frame.intersects(item2.frame) {
                                let temp_movingSpeed = (item as! BubbleButton).movingSpeed
                                (item as! BubbleButton).movingSpeed = (item2 as! BubbleButton).movingSpeed
                                (item2 as! BubbleButton).movingSpeed = temp_movingSpeed
                            }
                            self.removeOutOfBoundsBubbles()
                        }
                    }
                }
                
            }
        }
        
        // Remove all the bubbles which are outside of the bounds of the view
        self.removeOutOfBoundsBubbles()
        
    }
    
    /*
     * Suspending the timer
     */
    @IBAction func suspendTimer() {
        timerUpdater?.invalidate()
        timerUpdater = nil
        timerMover?.invalidate()
        timerMover = nil
    }
    
    /*
     * Stopping the timer
     */
    @IBAction func stopTimer() {
        timerUpdater?.invalidate()
        timerUpdater = nil
        timerMover?.invalidate()
        timerMover = nil
        initUI()
    }
    
    /*
     * Initailizing the game configuration and default value of remaining time and score
     */
    func initUI() {
        
        // 1.Initializing the settings of a game
        if self.settings == nil {
            self.settings = Settings()
        }
        
        // 2.Initializing the remaining time of a game according the settings of the game
        self.remainingTime = Int((self.settings?.playTime)!)
        self.lblRemainingTime.text = String(self.remainingTime!)
        
        // 3.Initializing the score of a player to zero
        self.score = 0
        self.lblScore.text = "0"
        
        // 4.Initializing the highest score from data file
        self.lblHighestScore.text = String(self.highestScore)
        
        // 5.Initailize the diameter of the bubbles dynamically according different size of different divice's screen
        if self.layout == nil {
            self.layout = Layout()
        }
        var countOfHorizentalBubbles = Int(Float(self.view.bounds.width) / Float((self.layout?.diameterOfBubble)!))
        var countOfVerticalBubbles = Int((Float(self.view.bounds.height) - Float(viewBoard.bounds.height)) / Float((self.layout?.diameterOfBubble)!))
        while countOfHorizentalBubbles * countOfVerticalBubbles < (self.settings?.maxBubbles)! {
            self.layout?.diameterOfBubble -= 1
            countOfHorizentalBubbles = Int(Float(self.view.bounds.width) / Float((self.layout?.diameterOfBubble)!))
            countOfVerticalBubbles = Int((Float(self.view.bounds.height) - Float(viewBoard.bounds.height)) / Float((self.layout?.diameterOfBubble)!))
        }
        self.layout?.countOfHorizentalBubbles = countOfHorizentalBubbles
        self.layout?.countOfVerticalBubbles = countOfVerticalBubbles
        let marginLeft = (Int(self.view.bounds.width) % Int((self.layout?.diameterOfBubble)!)) / 2
        let marginTop = Int(self.lblRemainingTime.frame.maxY + self.viewBoard.bounds.height);
        self.layout?.marginLeft = Float(marginLeft)
        self.layout?.marginTop = Float(marginTop)
        
        // 6. Initialize the last tapped bubble, its default color is white
        btnLatestTappedBubble.bubble = Bubble(color: UIColor.white, points: 0)
        let imgBubble = UIImage(named: "bubble-white.png")
        btnLatestTappedBubble.setBackgroundImage(imgBubble, for: UIControlState.normal)
        
    }
    
    /*
     * Updating the remaining time revoked by the timer
     */
    @objc func updateUI () {
        
        if self.remainingTime! > 0 {
            // Update the remaining time
            self.remainingTime! -= 1
            self.lblRemainingTime.text = String(self.remainingTime!)
            
            // Update the bubbles displayed on screen
            self.updateBubbles()
            
        } else {
            
            // Navigate to ranking list view
            let rankingTableView = RankingTableViewController()
            rankingTableView.playerName = self.playerName
            rankingTableView.score = self.score
            let playAgain: UIBarButtonItem = UIBarButtonItem.init(title: "Play Again", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            rankingTableView.navigationItem.leftBarButtonItem = playAgain
            let home: UIBarButtonItem = UIBarButtonItem.init(title: "Home", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
            rankingTableView.navigationItem.rightBarButtonItem = home
            self.navigationController?.pushViewController(rankingTableView, animated: true)
            
            // Stop the all timers
            self.stopTimer()
            //            self.startTimer()
            self.initUI()
            self.initailizeBubbles()
        }
        
    }
    
    /*
     * Initailizing randomly bubbles per second
     */
    func initailizeBubbles() {
        
        // Intialize a random number of bubbles
        let numberOfBubbles = randomSource.nextInt(upperBound: (settings?.maxBubbles)!)
        let positions = Positioner.getAvailablePosition(layout: self.layout!, totalCount: numberOfBubbles, exceptivePositions: [])
        for position in positions {
            createBubble(at: position)
        }
        
    }
    
    /*
     * Removing random number of bubbles and creating random number of bubbles
     */
    func updateBubbles() {
        
        // 1.Generate a random number of bubbles to be removed（take the number of the current bubbles as the upperBound）
        let currentNumberOfBubbles = self.getCurrentBubbles().count
        let randomNumberOfRemovedBubbles = randomSource.nextInt(upperBound: currentNumberOfBubbles)
        
        // 2.Remove bubbles by the above random number generated in the previous step
        self.removeBubbles(by: randomNumberOfRemovedBubbles)
        
        // 3.Generate a random number of bubbles to be created (take the difference between the current number of bubbles and the maximum number as the upperBound), then create bubbles by the above random number generated in the previous step
        let maxNumberOfNewBubbles = (settings?.maxBubbles)! - self.getCurrentBubbles().count
        if maxNumberOfNewBubbles > 0 {
            let numberOfNewBubbles = randomSource.nextInt(upperBound: maxNumberOfNewBubbles)
            let exceptivePositions: [CGPoint] = getCurrentPositionsOfBubble()
            let positions = Positioner.getAvailablePosition(layout: self.layout!, totalCount: numberOfNewBubbles, exceptivePositions: exceptivePositions)
            for position in positions {
                createBubble(at: position)
            }
            //        createBubbles(with: numberOfNewBubbles)
        }
        
    }
    
    /*
     * Creating dynamically bubbles per second
     * position: the CGPoint of bubbles to be created
     */
    @objc func createBubble(at position: CGPoint) {
        
        // Judge if there is any bubble is at the same position
        var toCreate = true
        for item in self.view.subviews {
            if item is BubbleButton {
                
                if abs(item.frame.origin.y - position.y) < CGFloat((self.layout?.diameterOfBubble)!) &&
                    abs(item.frame.origin.x - position.x) < CGFloat((self.layout?.diameterOfBubble)!) {
                    toCreate = false
                }
            }
        }
        
        if toCreate{
            // Generate the random and available position for a bubble
            let btnBubbleView = BubbleButton(frame: CGRect(x: position.x, y: position.y, width: CGFloat((self.layout?.diameterOfBubble)!), height: CGFloat((self.layout?.diameterOfBubble)!)))
            
            // Create a bubble with a random color according the probability for appearance of differenct color
            btnBubbleView.bubble = Bubble.random()
            
            // Load the bubble's backgroundImage by its color
            let imgBubble = UIImage(named: BubbleImager.imagePath(color: (btnBubbleView.bubble?.color)!))
            btnBubbleView.setBackgroundImage(imgBubble, for: UIControlState.normal)
            
            // MARK: - Setup a random moving direction
            let idOfDirection = randomSource.nextInt(upperBound: 7)
            btnBubbleView.movingSpeed = Direction.randomDirection(with: idOfDirection, and: (self.settings?.is2DMode)!)
            
            // Rester the event touchUpInside for the bubble
            btnBubbleView.addTarget(self, action: #selector(bubbleTapped(_:)), for: .touchUpInside)
            
            self.view.addSubview(btnBubbleView)
        }
        
    }
    
    /// Making all bubbles disable and hidden
    func disableAllBubbles() {
        for item in self.view.subviews {
            if item is BubbleButton {
                (item as! BubbleButton).isEnabled = false
                (item as! BubbleButton).isHidden = true
            }
        }
    }
    
    /// Making all bubbles enable and visible
    @objc func enableAllBubbles() {
        for item in self.view.subviews {
            if item is BubbleButton {
                (item as! BubbleButton).isEnabled = true
                (item as! BubbleButton).isHidden = false
            }
        }
    }
    
    /*
     * Registering the event touchUpInside for a bubble
     */
    @objc func bubbleTapped(_ sender: BubbleButton) {
        
        // Judge if the tapped has the same color as the latest tapped bubble's, and then multiple 1.5 or 1
        if sender.bubble?.color == btnLatestTappedBubble.bubble?.color {
            self.score += Int(Float((sender.bubble?.points)!) * 1.5)
        } else {
            self.score += Int((sender.bubble?.points)!)
        }
        
        // Update the score of the player and judge if the current player's score is higher than the first score in the ranking list file
        self.lblScore.text = String(self.score)
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            
            let rightTransform  = CGAffineTransform(translationX: 10, y: 10)
            self.lblScore.transform = rightTransform
            self.lblScore.layer.setAffineTransform(CGAffineTransform(scaleX: 3, y: 3))
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                self.lblScore.transform = CGAffineTransform.identity
                self.lblScore.layer.setAffineTransform(CGAffineTransform.identity)
            })
        }
        if self.score > self.highestScore {
            lblHighestScore.text = String(self.score)
        }
        
        // Modify the current color as flag
        self.btnLatestTappedBubble.bubble?.color = (sender.bubble?.color)!
        let tempImage = UIImage(named: BubbleImager.imagePath(color: (sender.bubble?.color)!))
        self.btnLatestTappedBubble.setBackgroundImage(tempImage, for: UIControlState.normal)
        
        
        // Before removing the bubble, excute a zoom animation
        UIView.animate(withDuration: 0.1, delay: 0.1, options: [], animations: {
            sender.alpha = 0.2
            sender.layer.setAffineTransform(CGAffineTransform(scaleX: 10, y: 10))
        }) { (true) in
            sender.alpha = 1.0
            sender.layer.setAffineTransform(CGAffineTransform.identity)
            sender.removeFromSuperview()
        }
        
        
    }
    
    /*
     * Getting the array of all current bubbles
     */
    func getCurrentBubbles() -> [BubbleButton] {
        var bubbles: [BubbleButton] = []
        for item in self.view.subviews {
            if item is BubbleButton {
                bubbles.append(item as! BubbleButton)
            }
        }
        return bubbles
    }
    
    /*
     * Getting the array of positions of all current bubbles
     */
    func getCurrentPositionsOfBubble() -> [CGPoint] {
        var positions: [CGPoint] = []
        for item in self.view.subviews {
            if item is BubbleButton {
                positions.append(CGPoint(x: item.frame.origin.x, y: item.frame.origin.y))
            }
        }
        return positions
    }
    
    /*
     * Remoing the bubbles which are outside of the screen
     */
    @objc func removeOutOfBoundsBubbles() {
        for item in self.view.subviews {
            if item is BubbleButton && item.frame.origin.y < self.viewBoard.bounds.height {
                item.removeFromSuperview()
            }
        }
    }
    
    /*
     * Removing the bubbles by a specified number
     * number: a specified number of bubbles
     */
    func removeBubbles(by number: Int) {
        
        // If number of bubbles to be removed is greater than the number of the current bubbles, remove all bubbles
        if number >= self.getCurrentBubbles().count {
            self.removeAllBubbles()
            return
        }
        
        // If number of bubbles to be removed is less than the number of the current bubbles, remove bubbles by the number
        var i = 0
        for item in self.view.subviews {
            if i >= number {
                return
            }
            if (item is BubbleButton) {
                item.removeFromSuperview()
                i += 1
            }
        }
        
    }
    
    /*
     * Removing all bubbles
     */
    func removeAllBubbles() {
        for item in self.view.subviews {
            if item is BubbleButton {
                item.removeFromSuperview()
            }
        }
    }
    
}

