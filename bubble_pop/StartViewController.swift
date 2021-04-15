import UIKit

class StartViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtPlayerName: UITextField!
    
    override func viewDidLoad() {
        txtPlayerName.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // The main view of game should not have navigation item
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // After this view disappeared, the navigation item is shown to prepared for using
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    /*
     * Preparing and transfering the basic information to the next view
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Validate the player's input
        guard self.txtPlayerName.text != nil && !(self.txtPlayerName.text?.isEmpty)! else {
            self.shake(self.txtPlayerName)
            self.perform(#selector(
                shake(_:)), with: nil, afterDelay: 0.2)
            self.prompt()
            return
        }
        
        // After gettting valid input, transfer the player's name to the game settings view
        if let settingView = segue.destination as? SettingViewController {
            settingView.playerName = self.txtPlayerName.text
        }
        
        // After gettting valid input, if going to the game view, using the default game settings
        if let gameView = segue.destination as? GameViewController {
            gameView.playerName = self.txtPlayerName.text
        }
        
        // If going to the ranking list view, hiding the back button of it
        if let rankingTableView = segue.destination as? RankingTableViewController {
            rankingTableView.navigationItem.hidesBackButton = true
        }
    }
    
    /*
     * Shake a control to draw the user's attention to the focus of
     */
    @objc func shake(_ object: UIView) {
        
        UIView.animate(withDuration: 0.2, delay: 0, animations: {
            
            let rightTransform  = CGAffineTransform(translationX: 50, y: 0)
            object.transform = rightTransform
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.2, animations: {
                object.transform = CGAffineTransform.identity
            })
        }
        
    }
    
    /*
     * Pop-up prompt window
     */
    func prompt() {
        
        let sheet = UIAlertController.init(title: "Prompt Message", message: "Please input your name", preferredStyle: UIAlertControllerStyle.actionSheet)
        sheet.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
            
        }))
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    /*
     * Pop-up prompt window with animation
     */
    func promptWithAnimation() {
        
        let alert = UIView.init(frame: CGRect(x: 15, y: 180, width: self.view.frame.width-30, height: self.view.frame.height/4*3))
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(alert)
        alert.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
        alert.alpha = 0
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            alert.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            alert.alpha = 1.0
        }, completion: nil)
        
    }
    
    // For exit from any deeper pushed ViewController
    @IBAction func unwindToStartView(segue: UIStoryboardSegue) {
        
    }

}
