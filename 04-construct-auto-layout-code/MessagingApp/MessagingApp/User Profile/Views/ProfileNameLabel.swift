import UIKit

final class ProfileNameLabel: UILabel {

    override var text: String? {
        didSet {
            // Separate by spaces.
            guard let words = text?.components(separatedBy: .whitespaces) else { return }
            let joinedWords = words.joined(separator: "\n")
            guard text != joinedWords else { return } // Prevent infinite loop
            DispatchQueue.main.async { [weak self] in
                self?.text = joinedWords
            }
        }
    }

    init(fullName: String? = "Full Name") {
        super.init(frame: .zero)
        setTextAttributes()
        text = fullName
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setTextAttributes() {
        numberOfLines = 0
        textAlignment = .center
        font = .boldSystemFont(ofSize: 24)
    }
}
