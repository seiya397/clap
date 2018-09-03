//
//  teamInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import MobileCoreServices

class teamInfoRegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var belongTo: UITextField!
    @IBOutlet weak var sports: UITextField!
    @IBOutlet weak var managerName: UITextField!
    @IBOutlet weak var managerAge: UITextField!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var roleTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            self.ShowMessage(messageToDisplay: "ユーザー情報を取得できませんでした。")
            return
        }
        
        print("user id = \(String(describing: currentUser?.uid))")
        print("user email \(String(describing: currentUser?.email))")
        print("varified \(String(describing: currentUser?.isEmailVerified))")
        
        // Do any additional setup after loading the view.
        
        let storageReference = Storage.storage().reference()
        let profileImageDownloadUrlReference = storageReference.child("user/\(currentUser!.uid)/\(currentUser!.uid)-profileImage.jpg")
        
        profileImageDownloadUrlReference.downloadURL { url, error in
            if let error = error {
                // Handle any errors
                print("Error took place \(error.localizedDescription)")
            } else {
                // Get the download URL for 'images/stars.jpg'
                print("Profile image download URL \(String(describing: url!))")
                do {
                    let imageData:NSData = try NSData(contentsOf: url!)
                    let image = UIImage(data: imageData as Data)
                    self.userProfileImageView.image = image
                } catch {
                    print(error)
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) {
        let currentUser = Auth.auth().currentUser
        let dateUnix: TimeInterval = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: dateUnix)
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date) //現在時刻取得
        
        //----------------------------------------------------- firestore
        let messageData = ["name": managerName.text!, "age": managerAge.text!,"role":roleTextField.text!, "createAccount": dateStr, "clap": 3,"profileImage": "user/\(currentUser!.uid)/\(currentUser!.uid)-profileImage.jpg", "sports": sports.text!] as [String : Any]
        
        let belong = ["shozoku": belongTo.text!] as [String: Any]
        var ref: DocumentReference? = nil
        
//        db.collection("team").document("ddd").collection("belong").document("users").setData(userBasicInfo)
//        {
//            err in
//            if let err = err {
//                print("Error writing document: \(err)")
//            } else {
//                print("Document successfully written!")
//            }
//        }
        
        db.collection("team").document("ddd").setData(belong)
        db.collection("team").document("ddd").collection("users").document("user").setData(messageData)
        {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID")
            }
        }
        //-----------------------------------------------------

        //選択式にすべき！！！！！！！
    }
    
    
    @IBAction func uploadProfileImageTapped(_ sender: Any) {//storageに画像保存
        let profileImagePicker = UIImagePickerController()
        profileImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        profileImagePicker.mediaTypes = [kUTTypeImage as String]
        profileImagePicker.delegate = self
        present(profileImagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let profileImage = info[UIImagePickerControllerOriginalImage] as? UIImage, let optimizedImageData = UIImageJPEGRepresentation(profileImage, 0.6)
        {
            uploadProfileImage(imageData: optimizedImageData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadProfileImage(imageData: Data){ //firebaseStorageへのアップ
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)//while upload
        activityIndicator.startAnimating()
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        let StorageRefelence = Storage.storage().reference()
        let currentUser = Auth.auth().currentUser
        let profileImageRef = StorageRefelence.child("user").child(currentUser!.uid).child("\(currentUser!.uid)-profileImage.jpg")
        let uploadMetadata = StorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        profileImageRef.putData(imageData, metadata: uploadMetadata)
        {(uploadedImageMeta, error) in
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
            if error != nil {
                print("Error took place \(describing: error?.localizedDescription)")
                return
            } else {
                print("metadata of uploaded imageg \(String(describing: uploadedImageMeta))")
            }
        }
    }
    
    
    //認証用関数
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
