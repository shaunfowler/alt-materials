import UIKit

final class NewContactViewController: UIViewController {

    // MARK: - Properties
    private let profileImageView = ProfileImageView(borderShape: .squircle, boldBorder: false)

    private let firstNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "First name"
        return textField
    }()

    private let lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Last name"
        return textField
    }()

    private var constraints: [NSLayoutConstraint] = []

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "New Contact"
        setupLeftBarButton()
        setupRightBarButton()
        setupViewTapGesture()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        dismissKeyboard(view)
    }

    // MARK: - Layouts
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        if !constraints.isEmpty {
            NSLayoutConstraint.deactivate(constraints)
            constraints.removeAll()
        }
        setupViewLayout()
    }

    private func setupLeftBarButton() {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel, target: self, action: #selector(leftBarButtonItemDidTap(_:)))
        navigationItem.leftBarButtonItem = barButtonItem
    }

    private func setupRightBarButton() {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done, target: self, action: #selector(rightBarButtonItemDidTap(_:)))
        navigationItem.rightBarButtonItem = barButtonItem
    }

    private func setupViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - VFL
    private func setupViewLayout() {

        let safeAreaInsets = view.safeAreaInsets

        let marginSpacing: CGFloat = 16
        let topSpace = safeAreaInsets.top + marginSpacing
        let leadingSpace = safeAreaInsets.left + marginSpacing
        let trailingSpace = safeAreaInsets.right + marginSpacing

        var constraints = [NSLayoutConstraint]()

        [profileImageView, firstNameTextField, lastNameTextField].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        let profileImageViewVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-topSpacing-[profileImageView(profileImageViewHeight)]",
            options: [],
            metrics: [
                "topSpacing": topSpace,
                "profileImageViewHeight": 40
            ],
            views: [
                "profileImageView": profileImageView
            ])
        constraints += profileImageViewVerticalConstraints

        let textFieldsVerticalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-topSpacing-[firstNameTextField(profileImageView)]-textFieldsSpacing-[lastNameTextField(firstNameTextField)]",
            options: [.alignAllCenterX],
            metrics: [
                "topSpacing": topSpace,
                "textFieldsSpacing": 8
            ],
            views: [
                "firstNameTextField": firstNameTextField,
                "lastNameTextField": lastNameTextField,
                "profileImageView": profileImageView
            ]
        )
        constraints += textFieldsVerticalConstraints

        let lastNameTextFieldHorizontalContraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:[lastNameTextField(firstNameTextField)]",
            options: [],
            metrics: nil,
            views: [
                "lastNameTextField": lastNameTextField,
                "firstNameTextField": firstNameTextField
            ])
        constraints += lastNameTextFieldHorizontalContraints

        let profileImageViewToFirstNameTextFieldHorizontalConstraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-leadingSpace-[profileImageView(profileImageViewWidth)]-[firstNameTextField(>=200@1000)]-trailingSpace-|",
            options: [],
            metrics: [
                "leadingSpace": leadingSpace,
                "trailingSpace": trailingSpace,
                "profileImageViewWidth": 40
            ],
            views: [
                "profileImageView": profileImageView,
                "firstNameTextField": firstNameTextField
            ])
        constraints += profileImageViewToFirstNameTextFieldHorizontalConstraints


        NSLayoutConstraint.activate(constraints)
        self.constraints = constraints
    }

    // MARK: - Action
    @objc private func leftBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @objc private func rightBarButtonItemDidTap(_ sender: UIBarButtonItem) {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }

    @objc private func dismissKeyboard(_ sender: UIView) {
        DispatchQueue.main.async { [weak self] in
            self?.view.endEditing(true)
        }
    }
}
