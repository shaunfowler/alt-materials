import UIKit

class ProfileHeaderView: UIView {

    private let profileImageView = ProfileImageView(borderShape: .squircle)
    private let leftSpacerView = UIView()
    private let rightSpacerView = UIView()
    private let fullNameLabel = ProfileNameLabel()

    private let messageButton = UIButton.createSystemButton(withTitle: "Message")
    private let callButton = UIButton.createSystemButton(withTitle: "Call")
    private let emailButton = UIButton.createSystemButton(withTitle: "Email")

    private lazy var profileImageStackView = UIStackView(arrangedSubviews: [
        leftSpacerView, profileImageView, rightSpacerView
    ])

    private lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            profileImageStackView, fullNameLabel
        ])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    private lazy var actionStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            messageButton, callButton, emailButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var stackView: UIStackView  = {
        let stackView = UIStackView(arrangedSubviews: [
            profileStackView, actionStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray4

        setupStackView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),

            // 20 <-> 500 range
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            stackView.leadingAnchor.constraint(lessThanOrEqualTo: leadingAnchor, constant: 500),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),

            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.widthAnchor.constraint(equalTo: profileImageView.heightAnchor),

            leftSpacerView.widthAnchor.constraint(equalTo: rightSpacerView.widthAnchor)
        ])

        profileImageView.setContentCompressionResistancePriority(UILayoutPriority(251), for: .horizontal)
        profileImageView.setContentCompressionResistancePriority(UILayoutPriority(251), for: .vertical)

        fullNameLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        fullNameLabel.setContentHuggingPriority(.init(251), for: .vertical)
        fullNameLabel.setContentCompressionResistancePriority(.init(751), for: .vertical)

        messageButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
    }
}

private extension UIButton {
    static func createSystemButton(withTitle title: String)
    -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        return button
    }
}
