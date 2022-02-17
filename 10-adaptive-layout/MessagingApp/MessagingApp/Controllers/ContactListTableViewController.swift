import UIKit

protocol ContactListTableViewControllerDelegate: AnyObject {
  func contactListTableViewController(
    _ contactListTableViewController: ContactListTableViewController,
    didSelectContact selectedContact: Contact
  )
}

class ContactListTableViewController: UITableViewController {

  var contacts = [
    Contact(
      name: "Hillary Oliver",
      photo: "rw-logo",
      lastTime: Date(timeIntervalSinceNow: -3.2)),
    Contact(
      name: "Evan Derek",
      photo: "rw-logo",
      lastTime: Date(timeIntervalSinceNow: -10.4))
  ]
  
  private let cellIdentififer = "ContactCell"
  private let segueIdentifier = "ShowMessages"

  weak var delegate: ContactListTableViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: - Table View Delegate
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let messagesViewController = delegate as? MessagesViewController,
          let messagesNavigationController = messagesViewController.navigationController else { return }

    let selectedContact = contacts[indexPath.row]
    messagesViewController.contactListTableViewController(self, didSelectContact: selectedContact)

    splitViewController?.showDetailViewController(messagesNavigationController, sender: nil)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if(segue.identifier == segueIdentifier) {
      guard let messagesVC = segue.destination as? MessagesViewController else {
        return
      }
      guard let indexPath = tableView.indexPathForSelectedRow else {
        return
      }
      
      messagesVC.contact = contacts[indexPath.row]
    }
  }
  
  // MARK: - Table View Data Source
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contacts.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentififer,
      for: indexPath) as! ContactTableViewCell
    
    let contact = contacts[indexPath.row]
    cell.nameLabel.text = contact.name
    cell.lastMessageLabel.text = contact.lastMessage
    
    return cell
  }
}
