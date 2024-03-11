
import UIKit

import SnapKit

final class PostedCell: UICollectionViewCell {
  
  static var id: String { NSStringFromClass(Self.self).components(separatedBy: ".").last ?? "" }

  private lazy var locationLabel = UIHelper.shared.createBasePaddingLabel("인천",
                                                                          backgroundColor: .mainBlue,     textColor: .white)
  private lazy var titleLabel = UIHelper.shared.createSingleLineLabel("운동 같이해요")

  private lazy var profileImageView = UIImageView(image: UIImage(named: "PersonImg"))
  private lazy var countMemeberLabel = UIHelper.shared.createSingleLineLabel("0/14")
  
  private lazy var genderImageView = UIImageView(image: UIImage(named: "GenderMixImg"))
  private lazy var genderLabel = UIHelper.shared.createSingleLineLabel("무관")

  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    
    setViewShadow(backView: self)
    
    addSubviews()
    configure()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func addSubviews() {
    [
      locationLabel,
      titleLabel,
      profileImageView,
      countMemeberLabel,
      genderImageView,
      genderLabel
    ].forEach {
      addSubview($0)
    }
  }
  
  private func configure() {
    locationLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(20)
      $0.leading.equalToSuperview().offset(20)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(locationLabel.snp.bottom).offset(10)
      $0.leading.equalTo(locationLabel)
    }
    
    profileImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(20)
      $0.leading.equalTo(titleLabel)
    }
    
    countMemeberLabel.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(5)
    }
    
    genderImageView.snp.makeConstraints {
      $0.top.equalTo(profileImageView)
      $0.leading.equalTo(profileImageView.snp.trailing).offset(50)
    }
    
    genderLabel.snp.makeConstraints {
      $0.centerY.equalTo(profileImageView)
      $0.leading.equalTo(genderImageView.snp.trailing).offset(5)
    }
    
  }
  
  
  private func bind() {

  }
  
}


