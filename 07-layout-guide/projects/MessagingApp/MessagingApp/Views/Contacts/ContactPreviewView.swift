import UIKit

@IBDesignable final class ContactPreviewView: UIView {
  @IBOutlet var photoImageView: ProfileImageView!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var contentView: UIView!
  @IBOutlet var callButton: UIButton!
  
  let nibName = "ContactPreviewView"
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    loadView()
  }
  
  func loadView() {
    let bundle = Bundle(for: ContactPreviewView.self)
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiate(withOwner: self).first as! UIView

    view.frame = bounds
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    setupLayoutInView(view)
    addSubview(view)
  }

  private func setupLayoutInView(_ view: UIView) {

    let layoutGuide = UILayoutGuide()
    view.addLayoutGuide(layoutGuide)

    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    callButton.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      nameLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      nameLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      nameLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),

      callButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      callButton.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor)
    ])

    let margins = view.layoutMarginsGuide

    NSLayoutConstraint.activate([
      layoutGuide.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 5),
      layoutGuide.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
      layoutGuide.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
      layoutGuide.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
    ])
  }
}
