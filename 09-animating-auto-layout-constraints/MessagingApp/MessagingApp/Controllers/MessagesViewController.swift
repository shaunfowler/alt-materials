import UIKit

class MessagesViewController: UIViewController {

  private let defaultBackgroundColor = UIColor(
    red: 249/255.0,
    green: 249/255.0,
    blue: 249/255.0,
    alpha: 1)
  private var messages: [Message] = []

  private let toolbarView = ToolbarView()
  private var toolbarViewTopConstraint: NSLayoutConstraint!

  @IBOutlet weak var tableView: UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = defaultBackgroundColor
    tableView.backgroundColor = defaultBackgroundColor
    
    loadMessages()
    setupToolbarView()

    let gesture = UITapGestureRecognizer()
    gesture.addTarget(self, action: #selector(hideToolbarView))
    gesture.numberOfTapsRequired = 1
    gesture.delegate = self
    tableView.addGestureRecognizer(gesture)
  }
  
  func loadMessages() {
    messages.append(Message(text: "Hello, it's me", sentByMe: true))
    messages.append(Message(text: "I was wondering if you'll like to meet, to go over this new tutorial I'm working on", sentByMe: true))
    messages.append(Message(text: "I'm in California now, but we can meet tomorrow morning, at your house", sentByMe: false))
    messages.append(Message(text: "Sound good! Talk to you later", sentByMe: true))
    messages.append(Message(text: "Ok :]", sentByMe: false))
  }

  func setupToolbarView() {

    view.addSubview(toolbarView)

    // Hide above view
    toolbarViewTopConstraint = toolbarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:  -200)
    toolbarViewTopConstraint.isActive = true

    toolbarView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true

    toolbarView.delegate = self
  }

  @objc func hideToolbarView() {

    self.toolbarViewTopConstraint.constant = -200

    UIView.animate(withDuration: 1) {
      self.toolbarView.alpha = 0
      self.view.layoutIfNeeded()
    }
  }
}

//MARK: - UITableView Delegate & Data Source
extension MessagesViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return messages.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //1
    let message = messages[indexPath.row]
    
    //2
    let cellIdentifier = message.sentByMe ? "RightBubble" : "LeftBubble"
    
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                             for: indexPath) as! MessageBubbleTableViewCell
    cell.messageLabel.text = message.text
    cell.backgroundColor = defaultBackgroundColor
    cell.delegate = self
    return cell
  }
}

extension MessagesViewController: MessageBubbleTableViewCellDelegate {
  func doubleTapForCell(_ cell: MessageBubbleTableViewCell) {

    // Check if message is yours
    guard let indexPath = tableView.indexPath(for: cell) else { return }
    let message = messages[indexPath.row]
    guard message.sentByMe == false else { return }

    toolbarView.tag = indexPath.row

    print("double tap", indexPath.row)
    toolbarViewTopConstraint.constant = cell.frame.midY
    toolbarView.alpha = 0.95

    print(messages.map { $0.isFavorited })

    print(message)
    toolbarView.update(
          isLiked: message.isLiked,
          isFavorited: message.isFavorited)

    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
}

extension MessagesViewController: UIGestureRecognizerDelegate {
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    touch.view == tableView // ensure table view is tapped an not it's children!
  }
}

extension MessagesViewController: ToolbarViewDelegate {
  func toolbarView(_ toolbarView: ToolbarView, didFavoritedWith tag: Int) {
    print("favorite tag", tag)
    messages[tag].isFavorited.toggle()
  }

  func toolbarView(_ toolbarView: ToolbarView, didLikedWith tag: Int) {
    print("like tag", tag)
    messages[tag].isLiked.toggle()
  }
}
