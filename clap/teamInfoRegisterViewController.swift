//
//  teamInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import MobileCoreServices

class teamInfoRegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var belongTo: UITextField!
    
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let currentUser = Auth.auth().currentUser
        
        if currentUser == nil {
            self.ShowMessage(messageToDisplay: "ユーザー情報を取得できませんでした。")
            return
        }
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) { //登録ボタン
        let currentUser = Auth.auth().currentUser
        let dateUnix: TimeInterval = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: dateUnix)
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date) //現在時刻取得
        
        //----------------------------------------------------- userDefaults
        let randomStringToUserID = self.randomString(length: 20)
        let userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["userID": randomStringToUserID])//それをuserDefaultsでstorageに格納
        userDefaults.synchronize()
        let userID: String = userDefaults.string(forKey: "userID")!//呼び出してきて、変数に格納
        
        let randomStringToTeamID = self.randomString(length: 20)
        userDefaults.register(defaults: ["teamID": randomStringToTeamID])
        userDefaults.synchronize()
        let teamID: String = userDefaults.string(forKey: "teamID")!//teamID生成
        
        //-----------------------------------------------------
        
        
        //----------------------------------------------------- firestore
        let messageData = [ "createAccount": dateStr, "clap": 3,] as [String : Any]

        
        let belong = ["belong": belongTo.text!] as [String: Any]
        
        var ref: DocumentReference? = nil
        
        db.collection("team").document(teamID).setData(belong)
        
        db.collection("users").document(userID).setData(messageData)
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
    
    public func ShowMessage(messageToDisplay: String) { //認証用関数
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
