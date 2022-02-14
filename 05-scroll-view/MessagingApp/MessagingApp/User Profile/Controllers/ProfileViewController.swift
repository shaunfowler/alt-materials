import UIKit

final class ProfileViewController: UIViewController {

    // MARK: - Properties
    private let profileHeaderView = ProfileHeaderView()
    private let mainStackView = UIStackView()
    private let scrollView = UIScrollView()

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupScrollView()
        setupMainStackView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Layouts
    private func setupProfileHeaderView() {
        profileHeaderView.translatesAutoresizingMaskIntoConstraints = false
        profileHeaderView.heightAnchor.constraint(equalToConstant: 360).isActive = true
        mainStackView.addArrangedSubview(profileHeaderView)
    }

    private func setupMainStackView() {
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            // Scroll view takes on width of content, so add this to stretch full width of view
            mainStackView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor), // SALG on anchors!

            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
        ])

        setupProfileHeaderView()
        setupButtons()
    }

    // Constraints between a scroll view and the views outside of its view hierarchy act on the scroll view’s frame.
    // Constraints between a scroll view and views inside of its view hierarchy act on the scroll view’s content area.
    // Remember to use frameLayoutGuide and contentLayoutGuide when creating the constraints for scroll views.
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.frameLayoutGuide.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.frameLayoutGuide.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.frameLayoutGuide.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.frameLayoutGuide.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Buttons Configuration
extension ProfileViewController {

    private func createButton(text: String, color: UIColor = .blue) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.setTitle(text, for: .normal)
        button.setTitleColor(color, for: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .left

        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }

    @objc private func buttonPressed(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel?.text ?? ""
        let message = "\(buttonTitle) button has been pressed"

        let alert = UIAlertController(
            title: "Button Pressed",
            message: message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    func setupButtons() {
        let buttonTitles = [
            "Share Profile", "Favorites Messages", "Saved Messages",
            "Bookmarks", "History", "Notifications", "Find Friends",
            "Security", "Help", "Logout"
        ]

        let buttonStack = UIStackView()
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.alignment = .fill
        buttonStack.axis = .vertical
        buttonStack.distribution = .equalSpacing

        buttonTitles.forEach { buttonTitle in
            buttonStack.addArrangedSubview(createButton(text: buttonTitle))
        }

        mainStackView.addArrangedSubview(buttonStack)
        NSLayoutConstraint.activate([
            buttonStack.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
            buttonStack.centerXAnchor.constraint(equalTo: mainStackView.centerXAnchor)
        ])
    }
}
