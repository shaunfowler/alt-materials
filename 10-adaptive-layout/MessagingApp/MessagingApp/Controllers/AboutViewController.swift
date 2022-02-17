import UIKit

class AboutViewController: UIViewController {

  private var contactButtonConstraints: [NSLayoutConstraint] = []

  lazy var contactUsButton: UIButton = {
    let button =  UIButton()
    button.backgroundColor = .white
    button.setTitleColor(.blue, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.layer.cornerRadius = 20.0
    button.layer.borderWidth = 1.0
    button.layer.borderColor = UIColor.blue.cgColor
    button.setImage(UIImage(named:"info"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(contactUsButton)
    setupContactUsButton(verticalSizeClass: traitCollection.verticalSizeClass)
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    setupContactUsButton(verticalSizeClass: traitCollection.verticalSizeClass)
  }

  private func setupContactUsButton(verticalSizeClass: UIUserInterfaceSizeClass) {

    NSLayoutConstraint.deactivate(contactButtonConstraints)

    if verticalSizeClass == .compact {
      contactUsButton.setTitle("Contact Us", for: .normal)

      contactButtonConstraints = [
        contactUsButton.widthAnchor.constraint(equalToConstant: 160),
        contactUsButton.heightAnchor.constraint(equalToConstant: 40),
        contactUsButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
        contactUsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
      ]
    } else {
      contactUsButton.setTitle("", for: .normal)

      contactButtonConstraints = [
        contactUsButton.widthAnchor.constraint(equalToConstant: 40),
        contactUsButton.heightAnchor.constraint(equalToConstant: 40),
        contactUsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        contactUsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
      ]
    }

    NSLayoutConstraint.activate(contactButtonConstraints)
  }
}
