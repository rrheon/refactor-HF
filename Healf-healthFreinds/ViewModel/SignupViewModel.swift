//
//  SignupViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 3/27/24.
//

import Foundation

import FirebaseAuth
import KakaoSDKAuth
import KakaoSDKUser
import AuthenticationServices
import FirebaseDatabase

protocol LoginViewModelDelegate: AnyObject {
  func loginDidSucceed(completion: @escaping() -> Void)
  func loginDidFail(with error: Error)
}

class SignupViewModel: CommonViewModel {
  weak var delegate: LoginViewModelDelegate?

  // MARK: - 로그인함수
  func loginToHealf(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
      if error == nil {
        // 로그인 성공
        self?.delegate?.loginDidSucceed {
          print("로그인 성공")
        }
      } else {
        // 로그인 실패
        self?.delegate?.loginDidFail(with: error!)
        print("로그인 실패")
        print(error.debugDescription)
      }
    }
  }
  
  // MARK: - 계정등록 함수
  func registerUserData(email: String, password: String, nickname: String,
                        completion: @escaping () -> Void){
    Auth.auth().createUser(withEmail: email,
                           password: password) { result, error in
      if let error = error {
        self.loginToHealf(email: email, password: String(password))
        print("Error creating user:", error.localizedDescription)
        return
      }
      
      guard let uid = result?.user.uid else {
        print("Error: UID is nil.")
        return
      }
      
      self.registerUserData(uid: uid, nickname: nickname) {
        completion()
      }
    }
  }
  
  func registerUserData(uid: String, nickname: String, completion: @escaping () -> Void) {
    let values = ["nickname": nickname,
                  "uid": uid,
                  "profileImage": "없음"]
    
    let valuesForUserData = ["nickname": nickname,
                             "uid": uid,
                             "togetherCount": 0,
                             "workoutCount": 0,
                             "postCount": 0,
                             "profileImage": "없음",
                             "location": "없음",
                             "introduce": "없읍"] as [String : Any]
    
    
    // Replace "." with "_" in the UID to create a valid database path
    let sanitizedUID = uid.replacingOccurrences(of: ".", with: "_")
    
    self.ref.child("UserDataInfo").child(sanitizedUID).setValue(valuesForUserData) { (error, ref) in
      if let error = error {
        print("Error setting user data:", error.localizedDescription)
        return
      }
      
      print("User data successfully saved to database.")
    }
    
    self.ref.child("UserData").child(sanitizedUID).setValue(values) { (error, ref) in
      if let error = error {
        print("Error setting user data:", error.localizedDescription)
        return
      }
      completion()
      print("User data successfully saved to database.")
    }
  }
  
  // MARK: - 카카오로그인 함수
  func kakaoLogin(){
    if (UserApi.isKakaoTalkLoginAvailable()) {
      UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
        if let error = error {
          print(error)
        }
        else {
          print("loginWithKakaoTalk() success.")
          
          //do something
          self.kakaoAuthSignIn()
          _ = oauthToken
        }
      }
    }
  }
  
  // MARK: - KakaoAuth SignIn Function
  func kakaoAuthSignIn() {
    if AuthApi.hasToken() { // 발급된 토큰이 있는지
      UserApi.shared.accessTokenInfo { _, error in // 해당 토큰이 유효한지
        if let error = error { // 에러가 발생했으면 토큰이 유효하지 않다.
          self.openKakaoService()
        } else { // 유효한 토큰
          self.loadingInfoDidKakaoAuth()
        }
      }
    } else { // 만료된 토큰
      self.openKakaoService()
    }
  }
  
  func openKakaoService() {
    if UserApi.isKakaoTalkLoginAvailable() { // 카카오톡 앱 이용 가능한지
      UserApi.shared.loginWithKakaoTalk { oauthToken, error in // 카카오톡 앱으로 로그인
        if let error = error { // 로그인 실패 -> 종료
          print("Kakao Sign In Error: ", error.localizedDescription)
          return
        }
        
        _ = oauthToken // 로그인 성공
        self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
      }
    } else { // 카카오톡 앱 이용 불가능한 사람
      UserApi.shared.loginWithKakaoAccount { oauthToken, error in // 카카오 웹으로 로그인
        if let error = error { // 로그인 실패 -> 종료
          print("Kakao Sign In Error: ", error.localizedDescription)
          return
        }
        _ = oauthToken // 로그인 성공
        self.loadingInfoDidKakaoAuth() // 사용자 정보 불러와서 Firebase Auth 로그인하기
      }
    }
  }
  
  func loadingInfoDidKakaoAuth() {  // 사용자 정보 불러오기
    UserApi.shared.me { kakaoUser, error in
      if let error = error {
        print("카카오톡 사용자 정보 불러오는데 실패했습니다.")
        
        return
      }
      guard var email = kakaoUser?.kakaoAccount?.email else { return }
      guard let password = kakaoUser?.id else { return }
      guard let userName = kakaoUser?.kakaoAccount?.profile?.nickname else { return }
      
      email = "kakao_\(email)"
      self.registerUserData(email: email, password: String(password), nickname: userName) {
        self.loginToHealf(email: email, password: String(password))
      }
    }
  }
  
  // MARK: - 애플로그인
  func appleLogin(authorization: ASAuthorization,
                  currentNonce: String?, completion: @escaping() -> Void){
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
       completion()
      }
    }
  }
  // MARK: - 애플로그인 시 유저 정보 등록
  func searchUID(){
    ref.child("UserDataInfo").observeSingleEvent(of: .value) { snapshot in
      if snapshot.exists() {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        for child in snapshot.children {
          if let snap = child as? DataSnapshot,
             let searchUid = snap.key as? String,
             searchUid == uid {
            // 원하는 uid를 찾았을 때의 처리
            print("내 uid를 찾았습니다.")
            return
          }
        }
        let userNum = Int.random(in: 1..<10000)
        self.registerUserData(uid: uid, nickname: "user\(userNum)") {
          print("계정등록완료")
        }
        // 원하는 uid를 찾지 못했을 때의 처리
        print("원하는 uid를 찾을 수 없습니다.")
      } else {
        // 데이터가 없을 때의 처리
        print("데이터가 없습니다.")
      }
    }
  }
}
