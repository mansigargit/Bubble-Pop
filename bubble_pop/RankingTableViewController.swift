import UIKit

class RankingTableViewController: UITableViewController {

    // Being used to accessing resources
    let bundle = Bundle.main
    
    // Being used to load all items of ranking list from file ranking.plist
    lazy var loadedRankingList: Array<Dictionary<String, String>> = {
        let filePath = self.bundle.path(forResource: "ranking", ofType: ".plist") // let picsPath = bundle.path(forResource: "ranking.plist", ofType: nil)
        return NSArray.init(contentsOfFile: filePath!) as! Array<Dictionary<String, String>>
    }()
    
    // Being used to store model ranking list for table view's cell
    var rankings: [Ranking] = []
    
    var playerName: String?
    
    var score: Int?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Ranking List"
        if let left = self.navigationItem.leftBarButtonItem {
            if left.title == "Play Again" {
                left.action = #selector(playOneMore)
                left.target = self
            }
        }
        if let right = self.navigationItem.rightBarButtonItem {
            if right.title == "Home" {
                right.action = #selector(back2StartView)
                right.target = self
            }
        }
        
    }
    
    /*
     * Go back to game view
     */
    @objc func playOneMore() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // Go to the main view (home page)
    @objc func back2StartView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Write the current player's score to the data file of ranking list
        self.writeNewRankingRecord()
        
        // Load the up-to-date ranking list from data file
        self.loadRankingList()
        
    }
    
    /*
     * Writing the current player's score into the data file
     */
    func writeNewRankingRecord()  {
        
        if let playerName = self.playerName, let score = self.score {
            
            // Replace the current player's existing highest score record if they got a higher score
            for i in 0..<self.loadedRankingList.count {
                if loadedRankingList[i]["playerName"]! == playerName &&
                    Int(loadedRankingList[i]["highestScore"]!)! < score {
                    self.loadedRankingList.remove(at: i)
                    self.loadedRankingList.insert(["playerName": playerName, "highestScore": String(score)], at: i)
                }
            }
            
            // If current player is a new one, to judge the ranking of score and determine the position that should be inserted
            var position = self.loadedRankingList.count
            var toInsert = true
            for i in 0..<self.loadedRankingList.count {
                if loadedRankingList[i]["playerName"]! != playerName &&
                    Int(loadedRankingList[self.loadedRankingList.count-i-1]["highestScore"]!)! < score {
                    position = self.loadedRankingList.count - i - 1
                } else if loadedRankingList[i]["playerName"]! == playerName {
                    toInsert = false
                }
            }
            if toInsert {
                self.loadedRankingList.insert(["playerName": playerName, "highestScore": String(score)], at: position)
            }
            
            // Execute the writing new ranking list to the data file
            let filePath = self.bundle.path(forResource: "ranking", ofType: ".plist")
            NSArray(array: self.loadedRankingList).write(toFile: filePath!, atomically: true)
        }
    }
    
    /*
     * Loading the up-to-date ranking list to the table view
     */
    func loadRankingList() {
        
        var ranking: Ranking = Ranking(level: "Noob", records: [])
        for item in self.loadedRankingList {
            let record: HighestScore = HighestScore(playerName: item["playerName"]!, highestScore: item["highestScore"]!)
            ranking.records.append(record)
        }
        self.rankings.append(ranking)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.rankings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rankings[section].records.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell", for: indexPath)
        var cell = tableView.dequeueReusableCell(withIdentifier: "rankingCell")
        if (cell == nil) {
            cell = UITableViewCell.init(style: UITableViewCellStyle.value1, reuseIdentifier: "rankingCell")
        }
        let ranking = self.rankings[indexPath.section]
        let record = ranking.records[indexPath.row]
        cell?.textLabel?.text = record.playerName
        cell?.detailTextLabel?.text = record.highestScore

        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return rankings[section].level
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
