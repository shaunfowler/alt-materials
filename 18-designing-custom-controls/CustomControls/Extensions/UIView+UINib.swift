import UIKit

extension UIView {

    func instantiateNib<T: UIView>(view: T) -> UIView {

        let nib = UINib(
            nibName: String(describing: T.self),
            bundle: Bundle(for: T.self)
        )

        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            fatalError("Failed to instantiate nib: \(T.self).")
        }

        return view
    }
}
