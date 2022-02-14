import UIKit

class ContactPreviewView: UIView {

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contentView: UIView!

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
        
        let nib = UINib(nibName: "ContactPreviewView", bundle: bundle)
        let view = nib.instantiate(withOwner: self).first as! UIView
        view.frame = bounds

        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8

        addSubview(view)
    }
}
