
import PlaygroundSupport
import UIKit

//: `view` is used for experimental purposes on this page.

let size = CGSize(width: 400, height: 400)
let frame = CGRect(origin: .zero, size: size)
let view = UIView(frame: frame)

//: # Sampling Pads

PlaygroundPage.current.liveView = view

/*:
 # Working with [live view](https://developer.apple.com/documentation/playgroundsupport/playgroundpage/1964506-liveview)
 ## Featuring rock, jazz and pop samples.
 ### By: Your Name
 */

//: [PreviousPage](@previous)
view.backgroundColor = .lightGray
view.backgroundColor = .blue
view.backgroundColor = .red
view.backgroundColor = .magenta


view.layer.cornerRadius = 50
view.layer.masksToBounds = true
view.layoutIfNeeded()


let label = UILabel()
label.backgroundColor = .white
view.addSubview(label)


label.translatesAutoresizingMaskIntoConstraints = false
let labelLeadingAnchorConstraint = label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8)
let labelTrailingAnchorConstraint = label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
let labelTopAnchorConstraint = label.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
labelLeadingAnchorConstraint.isActive = true
labelTrailingAnchorConstraint.isActive = true
labelTopAnchorConstraint.isActive = true
label.text = "Hello, wonderful people!"
view.layoutIfNeeded()


label.font = .systemFont(ofSize: 64, weight: .bold)
labelLeadingAnchorConstraint.constant = 24
labelTrailingAnchorConstraint.constant = -24
label.backgroundColor = .clear
label.text = "Hello!"
label.textAlignment = .center


label.removeConstraint(labelTopAnchorConstraint)
view.layoutIfNeeded()
label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
UIView.animateKeyframes(withDuration: 1, delay: 0, options: []) {
    view.layoutIfNeeded()
} completion: { _ in }

