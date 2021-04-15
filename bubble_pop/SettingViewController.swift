import UIKit

class SettingViewController: UIViewController {
    
    // Being used to store a player's name
    var playerName: String?
    
    // Being used to store the settings of the game
    var settings: Settings = Settings()
    
    @IBOutlet weak var sliGameTime: UISlider!
    
    @IBOutlet weak var sliMaxBubbles: UISlider!
    
    @IBOutlet weak var lblGameTime: UILabel!
    
    @IBOutlet weak var lblMaxBubbles: UILabel!
    
    @IBOutlet weak var swtIs2DMode: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the default value of slide of game time
        self.sliGameTime.maximumValue = 60
        self.sliGameTime.minimumValue = 10
        self.sliGameTime.value = 10
        lblGameTime.text = String(Int(sliGameTime.value))
        
        // Set the default value of slide of maximum number of bubbles in a game
        self.sliMaxBubbles.maximumValue = 15
        self.sliMaxBubbles.minimumValue = 1
        self.sliMaxBubbles.value = 15
        lblMaxBubbles.text = String(Int(sliMaxBubbles.value))
        
        self.settings.playTime = 10
        self.settings.maxBubbles = 15
    }
    
    /*
     * Updating the value of game time when draging on the slide of game time
     */
    @IBAction func changeGameTime(_ sender: UISlider) {
        self.lblGameTime.text = String(Int(self.sliGameTime.value))
        self.settings.playTime = TimeInterval(Int(self.sliGameTime.value))
    }
    
    /*
     * Updating the value of maximum number of bubbles in a game when draging on the slide of max bubbles
     */
    @IBAction func changeMaxBubbles(_ sender: Any) {
        self.lblMaxBubbles.text = String(Int(self.sliMaxBubbles.value))
        self.settings.maxBubbles = Int(self.sliMaxBubbles.value)
    }
    
    /*
     * Preparing and transfering the basic information to the next view
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameView = segue.destination as? GameViewController {
            gameView.playerName = self.playerName
            gameView.settings = self.settings
            gameView.settings?.is2DMode = self.swtIs2DMode.isOn
            print("*************** \(self.swtIs2DMode.isOn)")
        }
    }

}
