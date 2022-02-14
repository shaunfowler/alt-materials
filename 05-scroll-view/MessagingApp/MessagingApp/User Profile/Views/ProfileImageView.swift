import UIKit

final class ProfileImageView: UIImageView {
    // MARK: - Value Types
    enum BorderShape: String {
        case circle
        case squircle
        case square
        case none
    }
    
    // MARK: - Properties
    var hasBorder: Bool = false {
        didSet {
            layer.borderWidth = hasBorder ? 10 : 0
        }
    }
    
    private let borderShape: BorderShape
    
    // MARK: - Initializers
    init(borderShape: BorderShape) {
        self.borderShape = borderShape
        super.init(frame: CGRect.zero)
        layer.masksToBounds = true
        setupBorderShape()
    }
    
    convenience init() {
        self.init(borderShape: .none)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    // MARK: - Layouts
    private func setupBorderShape() {
        let hasBorder = borderShape != .none
        let borderWidth: CGFloat = hasBorder ? 10 : 0
        layer.borderWidth = borderWidth
        let width = bounds.size.width
        let divisor: CGFloat
        switch borderShape {
        case .circle:
            divisor = 2
        case .squircle:
            divisor = 4
        case .square, .none:
            divisor = width
        }
        let cornerRadius = width / divisor
        layer.cornerRadius = cornerRadius
    }
}
