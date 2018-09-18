//
//  userInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/27.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class userInfoRegisterViewController: UIViewController{

    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassAgain: UITextField!
    @IBOutlet weak var userRole: UITextField!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
        //---------------------------------------------------- 記入確認
        guard let userNameText = userName.text, !userNameText.isEmpty else {
            self.ShowMessage(messageToDisplay: "ユーザー名を記入してください。")
            return
        }
        guard let userEmailText  = userEmail.text, !userEmailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let userPassText = userPass.text, !userPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        guard let userPassAgainText = userPassAgain.text, !userPassAgainText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        guard let userRoleText = userRole.text, !userRoleText.isEmpty else {
            self.ShowMessage(messageToDisplay: "役割を記入してください。")
            return
        }
        //---------------------------------------------------- 記入確認
        //---------------------------------------------------- fireAuth
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPass.text!) { (user, error) in
            if let error = error {
                print("新規登録できませんでした")
                print(error.localizedDescription)
                self.ShowMessage(messageToDisplay: error.localizedDescription)
                return
            } else {
                print("新規登録成功しました")
                //login
                Auth.auth().signIn(withEmail: self.userEmail.text!, password: self.userPass.text!) { (user, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.ShowMessage(messageToDisplay: error.localizedDescription)
                        return
                    }
                    if let user = user {
                        print("ログインできました")
                        self.performSegue(withIdentifier: "schedule", sender: nil)
//                        let schedulePage = self.storyboard?.instantiateViewController(withIdentifier: "scheduleViewController") as! scheduleViewController
//                        self.present(schedulePage, animated: true, completion: nil)
                    }
                }
            }
        }
        //ログインしている現ユーザーUID取得
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        print("今度こそ\(fireAuthUID)")
        //---------------------------------------------------- fireAuth
        //--------------------------------------- createDate
        let dateUnix: TimeInterval = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: dateUnix)
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date) //現在時刻取得
        //--------------------------------------- createDate
        //--------------------------------------- fireStore
        let userDefaults:UserDefaults = UserDefaults.standard //userDefaultsでチームID取得
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        
        let registerData = ["name": userName.text!, "role": userRole.text!, "createDate": dateStr] as [String: Any]
        let userRegistInfo = ["regist": true, "teamID": teamID] as [String : Any]
        db.collection("team").document(teamID).collection("users").document(fireAuthUID).setData(userRegistInfo)
        {
            err in
            if let err = err {
                print("エラー \(err)")
            } else {
                print("登録成功")
            }
        }
        db.collection("users").document(fireAuthUID).setData(registerData)
        {
            err in
            if let err2 = err {
                print("登録できません")
            } else {
                print("登録成功")
            }
        }
        //--------------------------------------- fireStore
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
