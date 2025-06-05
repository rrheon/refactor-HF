import UIKit

import SnapKit

protocol BottomSheetDelegate: AnyObject {
  func firstButtonTapped(_ postedData: CreatePostModel?)
  func secondButtonTapped(_ postedData: CreatePostModel?)
}

final class BottomSheet: UIViewController {
  weak var delegate: BottomSheetDelegate?

  private let firstButtonTitle: String
  private let secondButtonTitle: String
  private var checkPost: Bool = false
  private var postedData: CreatePostModel?
  
  var deletePostButtonAction: (() -> Void)?
  var modifyPostButtonAction: (() -> Void)?

  init(firstButtonTitle: String = "삭제하기",
       secondButtonTitle: String = "수정하기",
       checkPost: Bool = false,
       postedData: CreatePostModel? = nil) {
    
    self.firstButtonTitle = firstButtonTitle
    self.secondButtonTitle = secondButtonTitle
    self.checkPost = checkPost
    self.postedData = postedData
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private lazy var firstButton: UIButton = {
    let button = UIButton()
    button.setTitle(firstButtonTitle, for: .normal)
    button.setTitleColor(.mainBlue, for: .normal)
    button.addAction(UIAction { _ in
      self.delegate?.firstButtonTapped(self.postedData)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var modifyButton: UIButton = {
    let button = UIButton()
    button.setTitle(secondButtonTitle, for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addAction(UIAction { _ in
      self.delegate?.secondButtonTapped(self.postedData)
    }, for: .touchUpInside)
    return button
  }()
  
  private lazy var dismissButton: UIButton = {
    let button = UIButton()
    button.setTitle("닫기", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.addTarget(self, action: #selector(dissMissButtonTapped), for: .touchUpInside)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    setUpLayout()
    makeUI()
  }
  
  func setUpLayout(){
    if checkPost { view.addSubview(modifyButton) }
    [
      firstButton,
      dismissButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  func makeUI(){
    firstButton.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(20)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview()
      make.height.equalTo(50)
    }
    
    if checkPost {
      modifyButton.snp.makeConstraints { make in
        make.top.equalTo(firstButton.snp.bottom).offset(10)
        make.centerX.equalToSuperview()
        make.height.equalTo(50)
      }
      
      dismissButton.snp.makeConstraints { make in
        make.top.equalTo(modifyButton.snp.bottom).offset(10)
        make.centerX.equalToSuperview()
        make.height.equalTo(50)
        make.width.equalTo(335)
      }
    } else {
      dismissButton.snp.makeConstraints { make in
        make.top.equalTo(firstButton.snp.bottom).offset(10)
        make.centerX.equalToSuperview()
        make.height.equalTo(50)
        make.width.equalTo(335)
      }
    }
  }
  
  @objc func dissMissButtonTapped(){
    dismiss(animated: true, completion: nil)
  }
}
