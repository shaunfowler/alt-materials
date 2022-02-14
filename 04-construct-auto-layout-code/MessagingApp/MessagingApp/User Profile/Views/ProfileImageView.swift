import UIKit

final class ProfileImageView: UIImageView {

    enum BorderShape: String {
        case circle
        case squircle
        case none
    }

    let boldBorder: Bool

    var hasBorder: Bool = false {
        didSet {
            guard hasBorder else {
                layer.borderWidth = 0
                return
            }
            layer.borderWidth = boldBorder ? 10 : 2
        }
    }

    private let borderShape: BorderShape

    init(borderShape: BorderShape, boldBorder: Bool = true) {
        self.borderShape = borderShape
        self.boldBorder = boldBorder
        super.init(frame: CGRect.zero)
        backgroundColor = .lightGray
    }

    convenience init() {
        self.init(borderShape: .none)
    }

    required init?(coder: NSCoder) {
        self.borderShape = .none
        self.boldBorder = false
        super.init(coder: coder)
    }

    // Layout

    /// Called when the constraint-based layout has finished its configuration.
    override func layoutSubviews() {
        super.layoutSubviews()
        setupBorderShape()
    }

    private func setupBorderShape() {
        hasBorder = borderShape != .none
        let width = bounds.size.width
        let divisor: CGFloat
        switch borderShape {
        case .circle:
            divisor = 2
        case .squircle:
            divisor = 4
        case .none:
            divisor = width
        }
        let cornerRadius = width / divisor
        layer.cornerRadius = cornerRadius
    }
}
