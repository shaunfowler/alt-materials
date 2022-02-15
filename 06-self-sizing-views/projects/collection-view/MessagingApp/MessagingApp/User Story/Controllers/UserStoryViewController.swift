import UIKit

final class UserStoryViewController: UIViewController {
  // MARK: - Properties
  private let userStory: UserStory
  private let cellIdentifier = "cellIdentifier"
  private let headerViewIdentifier = "headerViewIdentifier"
  private var currentItemIndex = 0
  
  private lazy var flowLayout: UICollectionViewFlowLayout = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    return flowLayout
  }()
  
  private lazy var collectionView: UICollectionView = {
    let collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .systemBackground
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.isPagingEnabled = true
    collectionView.bounces = false
    collectionView.register(StoryEventCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    collectionView.register(HeaderCollectionReusableView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: headerViewIdentifier)
    
    collectionView.dataSource = self
    collectionView.delegate = self
    
    return collectionView
  }()
  
  private lazy var storyProgressView: StoryProgressView = {
    let view = StoryProgressView(count: userStory.events.count)
    
    return view
  }()
  
  private lazy var swipeDownGesture: UISwipeGestureRecognizer = {
    let swipeGesture = UISwipeGestureRecognizer(
      target: self,
      action: #selector(dismissControllerAction))
    swipeGesture.direction = .down
    return swipeGesture
  }()
  
  // MARK: - Initializers
  init(userStory: UserStory) {
    self.userStory = userStory
    super.init(nibName: nil, bundle: nil)
    view.backgroundColor = .systemBackground
    title = "@\(userStory.username.rawValue)"
    setupNavigationBar()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addGestureRecognizer(swipeDownGesture)
    setupCollectionView()
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    centerCollectionViewContent()
    print("centering...")
  }
  
  // MARK: - Scroll View
  
  private func centerCollectionViewContent() {
    DispatchQueue.main.async { [weak self] in // BREAKS without dispatch, timing???
      guard let self = self else { return }
      let x: CGFloat = self.collectionView.frame.width * CGFloat(self.currentItemIndex)
      let y: CGFloat = 0
      let contentOffset = CGPoint(x: x, y: y)
      print("contentOffset", contentOffset, "; currentItemIndex", self.currentItemIndex)
      self.collectionView.setContentOffset(contentOffset, animated: false)
    }
  }
  
  // MARK: - Layouts
  private func setupCollectionView() {
    view.addSubview(storyProgressView)
    view.addSubview(collectionView)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    storyProgressView.translatesAutoresizingMaskIntoConstraints = false
    let safeAreaLayoutGuide = view.safeAreaLayoutGuide
    NSLayoutConstraint.activate([
      // stack progress view on top of story collection view
      storyProgressView.heightAnchor.constraint(equalToConstant: 40),
      storyProgressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      storyProgressView.widthAnchor.constraint(equalTo: collectionView.widthAnchor),
      storyProgressView.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: 20),
      
      collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      // collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  
  // MARK: UI
  private func setupNavigationBar() {
    let leftBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .cancel, target: self,
      action: #selector(dismissControllerAction))
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  // MARK: - Actions
  @objc private func dismissControllerAction() {
    DispatchQueue.main.async { [weak self] in
      self?.dismiss(animated: true, completion: nil)
    }
  }
}

// MARK: - UICollectionViewDataSource
extension UserStoryViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return userStory.events.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? StoryEventCollectionViewCell
    else { fatalError("Dequeued unregistered cell") }
    let item = indexPath.item
    let storyEvent = userStory.events[item]
    cell.configureCell(storyEvent: storyEvent)
    cell.backgroundColor = item % 2 == 0 ? .lightGray : .darkGray
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    guard let headerView = collectionView.dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: headerViewIdentifier,
      for: indexPath) as? HeaderCollectionReusableView else {
        fatalError("No header cell registered")
      }
    
    headerView.configureCell(username: userStory.username)
    return headerView
  }
}

extension UserStoryViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    collectionView.frame.size
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    .zero
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    // Make header a full-screen first "cell" of the collection view
    return collectionView.frame.size
  }
}

extension UserStoryViewController: UIScrollViewDelegate {
  
  // Set currentItemIndex based on position scrolled to
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let contentOffsetX = targetContentOffset.pointee.x
    let scrollViewWidth = scrollView.frame.width
    currentItemIndex = Int(contentOffsetX / scrollViewWidth)
    print(contentOffsetX, scrollViewWidth, currentItemIndex)
    
    // update progress view
    storyProgressView.currentItemIndex = currentItemIndex
  }
}

// MARK: - StoryProgressView

class StoryProgressView: UIView {
  
  let count: Int
  
  var currentItemIndex: Int = 0 {
    didSet {
      collectionView.reloadData()
    }
  }
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.scrollDirection = .horizontal
    flowLayout.minimumInteritemSpacing = 8
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.backgroundColor = .systemGray6
    
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "pc")
    
    collectionView.delegate = self
    collectionView.dataSource = self
    
    return collectionView
  }()
  
  init(count: Int) {
    self.count = count + 1 // +1 because addition of initial "user" cell in collection view
    super.init(frame: .zero)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    addSubview(collectionView)
    collectionView.fillSuperview()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension StoryProgressView: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pc", for: indexPath)
    
    if indexPath.row == currentItemIndex {
      cell.backgroundColor = .systemGreen
    } else {
      cell.backgroundColor = .clear
    }
    return cell
  }
}

extension StoryProgressView: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width: CGFloat = (collectionView.frame.width / CGFloat(self.count)) - (8.0 / CGFloat(self.count))
    return CGSize(width: width, height: 40)
  }
}
