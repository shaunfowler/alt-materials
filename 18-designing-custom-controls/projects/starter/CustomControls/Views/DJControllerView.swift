import UIKit

@IBDesignable final class DJControllerView: UIControl {

    // MARK: - Properties
    private lazy var view = instantiateNib(view: self)

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(view)
        view.fillSuperview(self)
    }
    
    // MARK: - Interface Builder
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        addLabelDescribing(view: self, insideSuperview: view)
    }
}
