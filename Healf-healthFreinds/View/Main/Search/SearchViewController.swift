
import UIKit

import SnapKit

final class SearchViewController: NaviHelper, UISearchBarDelegate {

  // MARK: - 서치바
  private let searchBar = UISearchBar.createSearchBar(placeholder: "원하는 지역을 입력해주세요.")
  private lazy var resultCollectionView = UIHelper.shared.createCollectionView(scrollDirection: .vertical,
                                                                               spacing: 20)
  private let scrollView = UIScrollView()
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  let searchViewModel = SearchViewModel()
  var userPostsArray: [CreatePostModel] = []
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationItemSetting()
    
    searchViewModel.loadAllPostsFromDatabase { result in
      self.userPostsArray = result

      self.setUpLayout()
      self.makeUI()
    }
  }
  
  override func navigationItemSetting() {
    super.navigationItemSetting()
    
    redesignNavigation("SearchTextImg")
  }
  
  // MARK: - makeUI
  func makeUI() {
    searchBar.delegate = self
    
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
    
    searchBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.equalToSuperview().offset(10)
      $0.trailing.equalToSuperview().offset(-10)
    }
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(searchBar.snp.bottom).offset(10)
      $0.leading.trailing.bottom.equalTo(view)
    }
  }
  
  func setUpLayout() {
    [
      searchBar,
      scrollView
    ].forEach {
      view.addSubview($0)
    }
    
    scrollView.addSubview(resultCollectionView)
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
