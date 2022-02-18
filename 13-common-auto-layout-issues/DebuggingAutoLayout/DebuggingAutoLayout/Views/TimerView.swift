import UIKit

class TimerView: UIView {
    var seconds = 0
    private var timer = Timer()
    private var timerLabel: UILabel!
    private var labelConstraints = [NSLayoutConstraint]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTimer()
    }
    
    func startTime() {
        timerLabel.text = "00 : 00"
        if timer.isValid {
            stopTimer()
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.seconds += 1
            self.timerLabel.text = self.formatSeconds(self.seconds)
        }
    }
    
    func stopTimer() {
        timer.invalidate()
        seconds = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTimer() {
        timerLabel = UILabel()
        timerLabel.text = "00 : 00"
        timerLabel.font = UIFont.boldSystemFont(ofSize: 13)
        timerLabel.textColor = .white
        timerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(timerLabel)
        needsUpdateConstraints()
    }
    
    private func formatSeconds(_ seconds: Int) -> String {
        let minutesPart: Int = seconds/60
        let secondsPart: Int = seconds % 60
        
        return "\(String(format: "%02d", minutesPart)) : \(String(format: "%02d",secondsPart))"
    }
    
    override func updateConstraints() {

        if labelConstraints.isEmpty {
            labelConstraints.append(timerLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor))
            labelConstraints.append(timerLabel.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor))

            NSLayoutConstraint.activate(labelConstraints)
        }

        super.updateConstraints()
    }
}
