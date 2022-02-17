import UIKit

class SettingsTableViewController: UITableViewController {

  override func awakeFromNib() {

    super.awakeFromNib()

    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissModal))

    modalPresentationStyle = .popover
    popoverPresentationController?.delegate = self
  }

  @objc func dismissModal() {
    dismiss(animated: true)
  }
}

extension SettingsTableViewController: UIPopoverPresentationControllerDelegate {
  func adaptivePresentationStyle(for controller: UIPresentationController,
                                 traitCollection: UITraitCollection) -> UIModalPresentationStyle {
    switch (traitCollection.horizontalSizeClass, traitCollection.verticalSizeClass) {
    case (.compact, .compact):
      return .fullScreen
    default:
      return .none
    }
  }

  func presentationController(_ controller: UIPresentationController,
                              viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController? {
    UINavigationController(rootViewController: controller.presentedViewController)
  }
}
