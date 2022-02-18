import UIKit

class ScoresTableViewController: UITableViewController {
    private var scores: [Score] = []
    private var firstTime = true
    
    override func viewDidAppear(_ animated: Bool) {
        scores = ScoreManager.shared.allScores()
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        let score = scores[indexPath.row]
        cell.textLabel?.text = "\(score.points) points in \(score.timeInSeconds) seconds"
        cell.detailTextLabel?.text = "\(formatDate(score.date))"
        
        return cell
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YYYY"
        return dateFormatter.string(from: date)
    }
    
    override func viewDidLayoutSubviews() {
        // 2022-02-17 17:41:44.604315-0800 DebuggingAutoLayout[87556:2029780] [LayoutLoop] Layout feedback loop debugging enabled via
        //     -UIViewLayoutFeedbackLoopDebuggingThreshold launch argument with a threshold of 100
        // view.setNeedsLayout()
    }
}
