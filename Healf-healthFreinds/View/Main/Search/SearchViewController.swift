
import UIKit

import SnapKit
import DropDown
import Then
import RxSwift

final class SearchViewController: NaviHelper {
    
  private lazy var selectLocationButton = UIButton().then {
    $0.setTitle("📍 지역: 전 체 ", for: .normal)
    $0.backgroundColor = .white
    $0.setTitleColor(.black, for: .normal)
    $0.layer.cornerRadius = 10
    $0.titleLabel?.font = .boldSystemFont(ofSize: 20)
    $0.setImage(UIImage(named: "SearchImg"), for: .normal)
    $0.semanticContentAttribute = .forceRightToLeft
    $0.addAction(UIAction { _ in
      self.selectLocationButtonTapped()
    }, for: .touchUpInside)
  }
  
  private lazy var resultCollectionView = uihelper.createCollectionView(scrollDirection: .vertical,
                                                                        spacing: 20)
  private lazy var noPostLabel = uihelper.createSingleLineLabel("❌ 등록된 게시글이 없습니다!")
  private let scrollView = UIScrollView()
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  let searchViewModel = SearchViewModel()
  var userPostsArray: [CreatePostModel] = []
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    bindViewModel()
    
    setUpLayout()
    makeUI()
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    redesignNavigation("SearchTextImg")
  }
  
  // MARK: - makeUI
  func makeUI() {
    resultCollectionView.delegate = self
    resultCollectionView.dataSource = self
    
    resultCollectionView.register(SearchResultCell.self,
                                  forCellWithReuseIdentifier: SearchResultCell.id)
    view.setNeedsLayout()
    view.layoutIfNeeded()
    
    resultCollectionView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(scrollView.snp.height)
    }
    
    selectLocationButton.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    
    noPostLabel.isHidden = true
    noPostLabel.snp.makeConstraints {
      $0.centerY.centerX.equalToSuperview()
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(selectLocationButton.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalTo(view)
    }
  }
  
  func setUpLayout() {
    [
      selectLocationButton,
      noPostLabel,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(resultCollectionView)
  }
  
  func bindViewModel(){
    searchViewModel.allPostDatas
      .observe(on: MainScheduler.instance) // UI 업데이트 코드를 메인 스레드에서 실행
      .subscribe(onNext: { [weak self] posts in
        guard let posts = posts else { return }
        self?.userPostsArray = posts
        self?.resultCollectionView.reloadData()
        
        self?.resultCollectionView.isHidden = self?.userPostsArray.count == 0 ? true : false
        self?.noPostLabel.isHidden = self?.userPostsArray.count == 0 ? false : true
      })
      .disposed(by: searchViewModel.disposeBag)
  }
  
  // 해당 버튼을 눌렀을 때 호출되는 함수
  func filterPostsButtonTapped(_ location: String) {
    let location = location == "전 체" ? nil : location
    searchViewModel.updateAllPosts(location: location)
  }
  
  func selectLocationButtonTapped(){
    let dropDownView = DropDown()
    dropDownView.dataSource = self.locations
    dropDownView.cellHeight = 40
    dropDownView.separatorColor = .black
    dropDownView.textFont = .boldSystemFont(ofSize: 20)
    dropDownView.anchorView = selectLocationButton
    dropDownView.cornerRadius = 5.0
    dropDownView.offsetFromWindowBottom = 80
    dropDownView.bottomOffset = CGPoint(x: 0, y: selectLocationButton.bounds.height)
    
    dropDownView.direction = .bottom
    dropDownView.show()
    
    dropDownView.selectionAction = { [unowned self] (index: Int, item: String) in
      selectLocationButton.setTitle("📍 지역: \(item)", for: .normal)
      filterPostsButtonTapped(item)
    }
  }
}

// MARK: - collectionView
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return self.userPostsArray.count
  }
  
//  func collectionView(_ collectionView: UICollectionView,
//                      didSelectItemAt indexPath: IndexPath) {
//    moveToPostedVC(userPostsArray[indexPath.row])
//  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.id,
                                                  for: indexPath) as! SearchResultCell
    cell.configure(with: userPostsArray[indexPath.row])
    cell.delegate = self
    
    return cell
  }
}

// 셀의 각각의 크기
extension SearchViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 350, height: 185)
  }
}

extension SearchViewController: ParticipateButtonDelegate {
  func participateButtonTapped(postedData: CreatePostModel) {
    moveToPostedVC(postedData)
  }
}
