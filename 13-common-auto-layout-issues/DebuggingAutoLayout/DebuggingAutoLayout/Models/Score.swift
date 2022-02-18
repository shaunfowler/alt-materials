import UIKit

struct Score {
    var timeInSeconds: Int
    var points: Int
    var date: Date
}


class ScoreManager {
    static let shared = ScoreManager()
    private var scores: [Score] = []
    
    func saveScore(_ score: Score) {
        scores.append(score)
    }
    
    func allScores() -> [Score] {
        return scores
    }
}
