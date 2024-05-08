//
//  EditMyProfileViewModel.swift
//  Healf-healthFreinds
//
//  Created by 최용헌 on 4/5/24.
//

import Foundation

import FirebaseStorage
import FirebaseDatabase

class EditMyProfileViewModel: CommonViewModel {
  func saveMyProfile(introduce: String, nickname: String, profileImage: UIImage){
    self.ref.child("UserDataInfo").child(self.uid ?? "").child("introduce").setValue(introduce)
    self.ref.child("UserDataInfo").child(self.uid ?? "").child("nickname").setValue(nickname)

    uploadImageToFirebaseStorage(image: profileImage)
  }
  
  func uploadImageToFirebaseStorage(image: UIImage) {
    guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
    
    let storageRef = Storage.storage().reference().child(uid ?? "").child("profileImage.jpg")
  
    storageRef.putData(imageData, metadata: nil) { (metadata, error) in
      guard let _ = metadata else {
        print("Error uploading image:", error?.localizedDescription ?? "Unknown error")
        return
      }
      
      // 이미지 업로드 성공
      storageRef.downloadURL { (url, error) in
        guard let downloadURL = url else {
          print("Error getting download URL:", error?.localizedDescription ?? "Unknown error")
          return
        }
        
        // Realtime Database에 다운로드 URL 저장
        self.saveImageDownloadURLToFirebaseDatabase(downloadURL: downloadURL.absoluteString)
      }
    }
  }
  
  func saveImageDownloadURLToFirebaseDatabase(downloadURL: String) {
    let ref = Database.database().reference().child("UserDataInfo").child(uid ?? "").child("profileImageURL")
   
    ref.setValue(downloadURL) { (error, ref) in
      if let error = error {
        print("Error saving image download URL:", error.localizedDescription)
      } else {
        print("Image download URL saved successfully!")
      }
    }
  }
}
