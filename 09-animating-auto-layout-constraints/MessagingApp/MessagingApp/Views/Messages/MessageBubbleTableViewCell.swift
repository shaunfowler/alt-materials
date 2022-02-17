import UIKit

protocol MessageBubbleTableViewCellDelegate: AnyObject {
  func doubleTapForCell(_ cell: MessageBubbleTableViewCell)
}

class MessageBubbleTableViewCell: UITableViewCell {

  @IBOutlet var messageLabel: UILabel!

  weak var delegate: MessageBubbleTableViewCellDelegate?

  override func awakeFromNib() {
    super.awakeFromNib()

    let gesture = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
    gesture.numberOfTapsRequired = 2
    gesture.cancelsTouchesInView = true
    contentView.addGestureRecognizer(gesture) // always use `contentView` in table cell
  }
  
  override func prepareForReuse() {
    messageLabel.text = ""
  }

  @objc func doubleTapped() {
    delegate?.doubleTapForCell(self)
  }
}
