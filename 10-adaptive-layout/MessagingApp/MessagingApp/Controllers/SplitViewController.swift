import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.viewControllers.forEach { print($0.self) }

        guard let leftNavController = viewControllers.first as? UINavigationController,
              let masterViewController = leftNavController.viewControllers.first as? ContactListTableViewController,
              let detailViewController = (viewControllers.last as? UINavigationController)?.topViewController as? MessagesViewController else {
                  fatalError("Oopsie")
              }

        let firstContact = masterViewController.contacts.first
        detailViewController.contact = firstContact
        masterViewController.delegate = detailViewController
        detailViewController.navigationItem.leftBarButtonItem = displayModeButtonItem
    }
}
