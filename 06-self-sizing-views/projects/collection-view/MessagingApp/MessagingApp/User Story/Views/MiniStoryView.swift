import UIKit

protocol MiniStoryViewDelegate: AnyObject {
  func didSelectUserStory(atIndex index: Int)
}

final class MiniStoryView: UIView {
  
  // MARK: - Properties
  private let userStories: [UserStory]
  private let cellIdentifier = "cellIdentifier"
  weak var delegate: MiniStoryViewDelegate?
  
  private let verticalInset: CGFloat = 8
  private let horizontalInset: CGFloat = 16
  
  private lazy var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumLineSpacing = 16
    flowLayout.scrollDirection = .horizontal
    flowLayout.sectionInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    return flowLayout
  }()
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.register(MiniStoryCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.alwaysBounceHorizontal = true // even when not full
    collectionView.backgroundColor = .systemGray6
    collectionView.dataSource = self
    collectionView.delegate = self
    return collectionView
  }()
  
  // MARK: - Initializers
  init(userStories: [UserStory]) {
    self.userStories = userStories
    super.init(frame: .zero)
    setupCollectionView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    self.userStories = []
    super.init(coder: aDecoder)
  }
  
  // MARK: - Layouts
  private func setupCollectionView() {
    addSubview(collectionView)
    collectionView.fillSuperview()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    let height = collectionView.frame.height - verticalInset * 2
    let width = height
    let itemSize = CGSize(width: width, height: height)
    flowLayout.itemSize = itemSize
  }
}

// MARK: - UICollectionViewDataSource
extension MiniStoryView: UICollectionViewDataSource {
  // 1
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userStories.count
  }
  
  // 2
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView .dequeueReusableCell(
      withReuseIdentifier: cellIdentifier,
      for: indexPath) as? MiniStoryCollectionViewCell
      else { fatalError("Dequeued Unregistered Cell") }
    let username = userStories[indexPath.item].username
    cell.configureCell(imageName: username.rawValue)
    return cell
  }
}

// MARK: - UICollectionViewDelegate
extension MiniStoryView: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    delegate?.didSelectUserStory(atIndex: indexPath.item)
  }
}
