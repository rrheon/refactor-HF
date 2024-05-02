//
//  ViewController.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 2024/01/11.
//

import UIKit

import SnapKit
import Then
import AuthenticationServices
import CryptoKit
import FirebaseAuth

// 소셜로그인 할 때 너무 오래걸림
final class LoginViewController: UIViewController {
  fileprivate var currentNonce: String?
  
  let signupViewModel = SignupViewModel()
  
  private lazy var titleLabel = UIHelper.shared.createMultipleLineLabel(
    "나만을 위한 헬스 친구 찾기,\nHeal F 🏋🏻",
    .black,
    .boldSystemFont(ofSize: 16),
    .left)
  
  private lazy var emailTextField = UIHelper.shared.createLoginTextField("아이디 또는 이메일")
  private lazy var passwordTextField = UIHelper.shared.createLoginTextField("비밀번호")
  
  private lazy var loginButton = UIHelper.shared.createHealfButton("로그인", .mainBlue, .white)
  
  private lazy var kakaoLoginButton = UIButton().then {
    $0.setImage(UIImage(named: "KakaoLoginImg"), for: .normal)
    $0.addAction(UIAction { _ in
      self.kakaoLoginButtonTapped()
    }, for: .touchUpInside)
  }
  
  private lazy var appleLoginButton = UIButton().then {
    let resizedImage = UIImage(named: "AppleLoginImg")?.resize(targetSize: .init(width: 300,
                                                                                 height: 200))
    $0.setImage(resizedImage,for: .normal)
    $0.addAction(UIAction { _ in
      self.appleLogin()
    }, for: .touchUpInside)
  }
  
  private lazy var signupButton = UIButton().then {
    $0.setTitle("이메일로 회원가입", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.setUnderline(.gray)
    $0.addAction(UIAction { _ in
      self.signupButtonTapped()
    }, for: .touchUpInside)
  }
  
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large)
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    signupViewModel.delegate = self
    
    setupLayout()
    makeUI()
  }
  
  // MARK: - setupLayout
  func setupLayout(){
    [
      titleLabel,
      emailTextField,
      passwordTextField,
      loginButton,
      kakaoLoginButton,
      appleLoginButton,
      signupButton
    ].forEach {
      view.addSubview($0)
    }
  }
  
  // MARK: - makeUI
  func makeUI(){
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(150)
      $0.leading.equalToSuperview().offset(20)
    }
    
    emailTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(100)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalToSuperview().offset(-20)
    }
    
    passwordTextField.isSecureTextEntry = true
    passwordTextField.snp.makeConstraints {
      $0.top.equalTo(emailTextField.snp.bottom).offset(50)
      $0.leading.trailing.equalTo(emailTextField)
    }
    
    loginButton.addAction(UIAction { _ in
      self.loginToHealf()
    }, for: .touchUpInside)
    loginButton.snp.makeConstraints {
      $0.top.equalTo(passwordTextField.snp.bottom).offset(40)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(48)
    }
    
    kakaoLoginButton.snp.makeConstraints {
      $0.top.equalTo(loginButton.snp.bottom).offset(60)
      $0.leading.trailing.equalTo(loginButton)
      //      $0.height.equalTo(48)
    }
    
    appleLoginButton.snp.makeConstraints {
      $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(20)
      $0.leading.trailing.equalTo(emailTextField)
      $0.height.equalTo(48)
    }
    
    signupButton.snp.makeConstraints {
      $0.top.equalTo(appleLoginButton.snp.bottom).offset(20)
      $0.centerX.equalTo(appleLoginButton)
    }
  }
  
  func loginToHealf() {
    guard let email = emailTextField.text?.description,
          let password = passwordTextField.text?.description else { return }
    signupViewModel.loginToHealf(email: email, password: password)
    activityIndicator.stopAnimating()
  }
  
  func kakaoLoginButtonTapped(){
    waitingNetworking()
    signupViewModel.kakaoLogin()
  }
  
  // MARK: - signupButtonTapped
  func signupButtonTapped(){
    let registerEmailVC = SignuplViewController()
    let navigationVC = UINavigationController(rootViewController: registerEmailVC)
    navigationVC.modalPresentationStyle = .fullScreen
    self.present(navigationVC, animated: true, completion: nil)
  }
  
  // 처음에 계정등록절차를 밟으면 될드
  func appleLogin(){
    let nonce = randomNonceString()
    currentNonce = nonce
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]
    request.nonce = sha256(nonce)
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
  
  func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
      fatalError(
        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
      )
    }
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    let nonce = randomBytes.map { byte in
      // Pick a random character from the set, wrapping around if needed.
      charset[Int(byte) % charset.count]
    }
    return String(nonce)
  }
  
  func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
      String(format: "%02x", $0)
    }.joined()
    
    return hashString
  }
  
  // MARK: - 네트워킹 기다릴 때
  func waitingNetworking(){
    view.addSubview(activityIndicator)
    
    activityIndicator.snp.makeConstraints {
      $0.centerX.centerY.equalToSuperview()
    }
    
    activityIndicator.startAnimating()
  }
}

extension LoginViewController: LoginViewModelDelegate {
  // MARK: - LoginViewModelDelegate
  func loginDidSucceed(completion: @escaping () -> Void) {
    let tapbarcontroller = TabBarController()
    tapbarcontroller.modalPresentationStyle = .fullScreen
    self.present(tapbarcontroller, animated: true, completion: nil)
    
    completion()
  }
  
  func loginDidFail(with error: Error) {
    UIHelper.shared.showToast(message: "❌ 아이디, 비밀번호를 확인해주세요")
  }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
      guard let nonce = currentNonce else {
        fatalError("Invalid state: A login callback was received, but no login request was sent.")
      }
      guard let appleIDToken = appleIDCredential.identityToken else {
        print("Unable to fetch identity token")
        return
      }
      guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
        print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
        return
      }
      
      // Initialize a Firebase credential, including the user's full name.
      let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
                                                     rawNonce: nonce,
                                                     fullName: appleIDCredential.fullName)

      // Sign in with Firebase.
      Auth.auth().signIn(with: credential) { authResult, error in
        if let error = error {
          print("Error Apple sign in: \(error.localizedDescription)")
          return
        }
        // 로그인에 성공했을 시 실행할 메서드 추가
        self.loginDidSucceed {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.signupViewModel.searchUID()
            }
        }

        
        // 처음 계정을 등록할 때 한번만 실행하도록..
        // userData에 해당 uid가 없으면 생성 아님 말고

     
        }
      }
    }
  
  func authorizationController(controller: ASAuthorizationController,
                               didCompleteWithError error: Error) {
    // 로그인 실패(유저의 취소도 포함)
    print("Sign in with Apple errored: \(error)")
  }
}

