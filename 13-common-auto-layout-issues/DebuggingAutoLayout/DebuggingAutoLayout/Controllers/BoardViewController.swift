import UIKit

class BoardViewController: UIViewController {
    var sequence: [Int] = []
    var buttons: [UIButton] = []
    var currentIndexSequence = 0

    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var playButton: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: UIView!
    let defaultDuration = 0.7
    let defautltDelay = 0.45

    //Points
    @IBOutlet weak var pointsLabel: UILabel!
    var points = 0

    //Timer
    let timerView = TimerView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    //MARK: - UI
    private func setupUI() {
        createBoard()
        setupTimer()
    }

    private func showPoints(_ points: Int) {
        pointsLabel.text = "Points: \(points)"
    }

    private func formatSeconds(_ seconds: Int) -> String {
        let minutesPart: Int = seconds/60
        let secondsPart: Int = seconds % 60

        return "\(String(format: "%02d", minutesPart)) : \(String(format: "%02d",secondsPart))"
    }

    private func setupTimer() {
        view.addSubview(timerView)
        timerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timerView.leadingAnchor.constraint(equalTo: pointsLabel.leadingAnchor),
            timerView.trailingAnchor.constraint(equalTo: pointsLabel.trailingAnchor),
            timerView.topAnchor.constraint(equalTo: pointsLabel.bottomAnchor, constant: 10),
            timerView.heightAnchor.constraint(equalToConstant: 15)
        ])
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        startGame()
    }

    //MARK: - Board
    private func blockBoard() {
        toggleBoard(false)
    }

    private func unBlockBoard() {
        toggleBoard(true)
    }

    private func toggleBoard( _ enable: Bool) {
        buttons.forEach { (button) in
            button.isEnabled = enable
        }
    }

    private func createBoard() {

        let boardStackView = UIStackView()
        boardStackView.axis = .vertical
        boardStackView.distribution = .fillEqually
        boardStackView.spacing = 10
        boardStackView.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(boardStackView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: boardStackView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: boardStackView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: boardStackView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: boardStackView.trailingAnchor)
        ])

        var tagFirstColumn = 0
        let numberOfColumns = 4
        let numberOfRows = 4

        for _ in 0..<numberOfRows {

            let boardRowStackView = UIStackView()
            boardRowStackView.axis = .horizontal

            // boardRowStackView.distribution = .equalSpacing
            // |   |   |   |   |   |   |   |   |   *UIStackView:0x7fb940b207c0
            // |   |   |   |   |   |   |   |   |   |   *UIButton:0x7fb94790bb90- AMBIGUOUS LAYOUT for UIButton:0x7fb94790bb90.Width{id: 82}
            // |   |   |   |   |   |   |   |   |   |   |   UIButtonLabel:0x7fb937718ef0
            // |   |   |   |   |   |   |   |   |   |   *UIButton:0x7fb94790c250- AMBIGUOUS LAYOUT for UIButton:0x7fb94790c250.minX{id: 109}, UIButton:0x7fb94790c250.Width{id: 88}
            // |   |   |   |   |   |   |   |   |   |   |   UIButtonLabel:0x7fb937718c00
            // |   |   |   |   |   |   |   |   |   |   *UIButton:0x7fb94790c510- AMBIGUOUS LAYOUT for UIButton:0x7fb94790c510.minX{id: 111}, UIButton:0x7fb94790c510.Width{id: 94}
            // |   |   |   |   |   |   |   |   |   |   |   UIButtonLabel:0x7fb937718910
            // |   |   |   |   |   |   |   |   |   |   *UIButton:0x7fb94790c7d0- AMBIGUOUS LAYOUT for UIButton:0x7fb94790c7d0.minX{id: 107}, UIButton:0x7fb94790c7d0.Width{id: 100}
            // |   |   |   |   |   |   |   |   |   |   |   UIButtonLabel:0x7fb9377169b0
            boardRowStackView.distribution = .fillEqually

            boardRowStackView.spacing = 10
            boardRowStackView.translatesAutoresizingMaskIntoConstraints = false

            for otherIndex in 0..<numberOfColumns {
                print(otherIndex + tagFirstColumn)
                let button = createButtonWithTag(otherIndex + tagFirstColumn)
                buttons.append(button)
                boardRowStackView.addArrangedSubview(button)
            }

            boardStackView.addArrangedSubview(boardRowStackView)
            tagFirstColumn += numberOfColumns
        }

        blockBoard()
    }

    private func createButtonWithTag(_ tagNumber: Int) -> UIButton {
        let button = UIButton(frame: .zero)
        button.tag = tagNumber
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button)

        return button
    }

    //MARK: - Gameplay

    private func startGame() {
        sequence = []
        currentIndexSequence = 0
        addElementToSequence()
        resultsLabel.text = ""
        points = 0
        showPoints(0)
        timerView.startTime()
    }

    private func animateButton(_ button: UIButton, delay: Double, completion:(() -> Void)? = nil) {
        UIView.animate(withDuration: defaultDuration , delay: delay, options: .curveEaseInOut, animations: {
            button.backgroundColor = .green
        }, completion: { (finished) in
            if finished {
                button.backgroundColor = .blue
                if let completion = completion {
                    completion()
                }
            }
        })
    }

    @objc private func buttonTapped(sender: UIButton) {
        animateButton(sender, delay: 0) { [weak self] in
            self?.submitPlay(sender.tag)
        }
    }

    private func addElementToSequence() {
        let randonNumber = Int.random(in: 0...15)
        sequence.append(randonNumber)

        previewSequence()
    }

    private func submitPlay(_ tagNumber: Int) {
        if(tagNumber == sequence[currentIndexSequence]) {
            currentIndexSequence += 1

            if currentIndexSequence == sequence.count {
                currentIndexSequence = 0
                showNextPlay()
            }
        }
        else {
            saveScore()
            showLoser()
        }
    }

    private func showNextPlay() {
        resultsLabel.text = " Nice, Keep Going! "
        resultsLabel.textColor = .blue

        points += 1
        showPoints(points)

        addElementToSequence()
    }

    private func previewSequence(_ index: Int = 0) {
        blockBoard()
        findAndAnimateButton(index: index)
    }

    private func findAndAnimateButton(index: Int) {
        let tag = sequence[index]
        let button = buttons.first { b in
            b.tag == tag
        }

        if let button = button {
            animateButton(button, delay: defautltDelay) { [weak self] in
                guard let self = self else { return }
                if self.sequence.count - 1 > index {
                    self.previewSequence(index + 1)
                }
                else {
                    self.unBlockBoard()
                }
            }
        }
    }

    private func showLoser() {
        resultsLabel.text = " Wrong sequence :( "
        resultsLabel.textColor = .red
        timerView.stopTimer()
        blockBoard()
    }

    private func saveScore() {
        let score = Score(timeInSeconds: timerView.seconds, points: points, date: Date())
        ScoreManager.shared.saveScore(score)
    }
}
