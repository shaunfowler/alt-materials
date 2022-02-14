import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Properties
    private let contactsNavigationController = NavigationController(tabBarTitle: .contacts)
    private let profileNavigationController = NavigationController(tabBarTitle: .profile)

    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        embedViewControllers()
    }

    // MARK: - UI
    private func embedViewControllers() {
        viewControllers = [
            profileNavigationController,
            contactsNavigationController]
    }
}

private final class NavigationController: UINavigationController {

    // MARK: - Initializers
    init(tabBarTitle: TabBarTitle) {
        let rootViewController: UIViewController
        switch tabBarTitle {
        case .contacts:
            let contactsStoryboard = UIStoryboard(name: "Contacts", bundle: nil)
            let viewController = contactsStoryboard.instantiateViewController(withIdentifier: "ContactListTableViewController")
            rootViewController = viewController
        case .profile:
            rootViewController = ProfileViewController()
        }
        rootViewController.title = tabBarTitle.rawValue
        super.init(rootViewController: rootViewController)
        tabBarItem.title = tabBarTitle.rawValue
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
