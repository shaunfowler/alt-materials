import UIKit

final class PitchControl: UIControl {

    // MARK: - IBOutlets

    @IBOutlet var thumbImageView: UIImageView!
    @IBOutlet var sliderBackgroundImageView: UIImageView!
    @IBOutlet var thumbImageViewTopConstraint: NSLayoutConstraint!
    
    // MARK: - Private UI Properties

    private lazy var view = instantiateNib(view: self)

    // MARK: - Private Data Properties

    private let minValue: CGFloat = 0
    private let maxValue: CGFloat = 10

    private var value: CGFloat = 1 {
        didSet {
            print("Value:", value)
        }
    }

    private var previousTouchLocation = CGPoint()

    // MARK: - Private Computed Properties

    private var valueRange: CGFloat {
        maxValue - minValue + 1
    }

    private var halfThumbImageViewHeight: CGFloat {
        thumbImageView.bounds.height / 2
    }

    private var distancePerUnit: CGFloat {
        // distance travel between value increment and decrement
        (sliderBackgroundImageView.bounds.height / valueRange) - (halfThumbImageViewHeight / 2)
    }

    // MARK: - Internal Properties

    override var accessibilityValue: String? {
        get {
            "\(Int(value))"
        }
        set {
            super.accessibilityValue = newValue
        }
    }
    
    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(view)
        view.isUserInteractionEnabled = false
        view.fillSuperview(self)
        setupAccessibilityElements()
    }
    
    // MARK: - Touch Tracking Handlers

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)

        previousTouchLocation = touch.location(in: self)
        print(previousTouchLocation, thumbImageView.frame)
        let isTouchingThumbImageView = thumbImageView.frame.contains(previousTouchLocation)

        thumbImageView.isHighlighted = isTouchingThumbImageView

        return isTouchingThumbImageView
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)

        let touchLocation = touch.location(in: self)
        let deltaLocation = touchLocation.y - previousTouchLocation.y
        print("delta y", deltaLocation)

        let deltaValue = (maxValue - minValue) * (deltaLocation / bounds.height)
        print("delta value", deltaValue, "%", deltaLocation / bounds.height)

        previousTouchLocation = touchLocation

        value = boundValue(value + deltaValue, toLowerValue: minValue, andUpperValue: maxValue)

        let isTouchingBackgroundImage = sliderBackgroundImageView.frame.contains(previousTouchLocation)

        // stop moving thumb image if touch moves outside background image!
        if isTouchingBackgroundImage {
            thumbImageViewTopConstraint.constant = touchLocation.y - self.halfThumbImageViewHeight
        }

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        thumbImageView.isHighlighted = false
    }

    // MARK: - Accessibility Features

    private func setupAccessibilityElements() {
        isAccessibilityElement = true
        accessibilityLabel = "Pitch"
        accessibilityTraits = [.adjustable]
        accessibilityHint = "Adjust pitch"
    }

    // react to a11y
    private func slideThumbInDirection(_ direction: Direction) {

        let valueChange: CGFloat
        switch direction {
        case .up: valueChange = 1
        case .down: valueChange = 1 * -1
        }

        let newValue = value + valueChange
        if newValue < minValue {
            value = minValue
        } else if newValue > maxValue {
            value = maxValue
        } else {
            value = newValue
        }

        thumbImageViewTopConstraint.constant = value * distancePerUnit
    }

    override func accessibilityIncrement() {
        super.accessibilityIncrement()
        slideThumbInDirection(.up)
    }

    override func accessibilityDecrement() {
        super.accessibilityDecrement()
        slideThumbInDirection(.down)
    }
    
    // MARK: - Helpers

    private func boundValue(
        _ value: CGFloat,
        toLowerValue lowerValue: CGFloat,
        andUpperValue upperValue: CGFloat) -> CGFloat {
            return min(max(value, lowerValue), upperValue)
        }
}

fileprivate enum Direction {
    case up
    case down
}
