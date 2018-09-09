//
//  userInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/27.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore
import MobileCoreServices

class userInfoRegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPosition: UITextField!
    @IBOutlet weak var userAge: UITextField!
    @IBOutlet weak var userJender: UITextField!
    @IBOutlet weak var userWeight: UITextField!
    @IBOutlet weak var userHeight: UITextField!
    @IBOutlet weak var teamID: UITextField!
    @IBOutlet weak var userProfileImage: UIImageView!
    
    var databaseRef:DatabaseReference!
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
        var databaseReference:DatabaseReference!
        databaseRef = Database.database().reference()
        
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
                    self.userProfileImage.image = image
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
    
    @IBAction func userInfoRegisterButton(_ sender: Any) {
        
        //----------------------------------------------------- userDefaults
        let randomStringToUserID = self.randomString(length: 20)
        let userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["userID": randomStringToUserID])//それをuserDefaultsでstorageに格納
        userDefaults.synchronize()
        let userID: String = userDefaults.string(forKey: "userID")!//呼び出してきて、変数に格納

        //-----------------------------------------------------
        
        let userBasicInfo = ["userName": userName.text!, "userAge": userAge.text!, "userWight": userWeight.text!, "userHeight": userHeight.text!] as [String : Any]
        
        //----------------------------------------------------- firestore
        var ref: DocumentReference? = nil
        
        db.collection("users").document(userID).setData(userBasicInfo)
        {
            err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
        
        //----------------------------------------------------- firestore
        //選択式にすべき！！！！！！！
    }
    
    @IBAction func userProfileUploadButtonTapped(_ sender: Any) {//uploadImage
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
    
    func randomString(length: Int) -> String {  //ランダムID
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    func uploadProfileImage(imageData: Data){ //firebaseStorageへのアップ
        let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
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
