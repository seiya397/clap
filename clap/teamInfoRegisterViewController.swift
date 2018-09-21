//
//  teamInfoRegisterViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/08/26.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import MobileCoreServices

class teamInfoRegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var belongTo: UITextField!
    @IBOutlet weak var kindOfPerson: UITextField!
    
    @IBOutlet weak var teamSports: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) { //登録ボタン
        
        guard let belongText = belongTo.text, !belongText.isEmpty else {
            self.ShowMessage(messageToDisplay: "チーム名を記入してください。")
            return
        }
        guard let kindText = kindOfPerson.text, !kindText.isEmpty else {
            self.ShowMessage(messageToDisplay: "種別を記入してください。")
            return
        }
        guard let sportsText = teamSports.text, !sportsText.isEmpty else {
            self.ShowMessage(messageToDisplay: "競技項目を記入してください。")
            return
            
        }
        
        let dateUnix: TimeInterval = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: dateUnix)
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date) //現在時刻取得
        
        //----------------------------------------------------- userDefaults
        let userDefaults:UserDefaults = UserDefaults.standard
        let randomStringToTeamID = self.randomString(length: 20)
        userDefaults.set(randomStringToTeamID, forKey: "teamID")
        userDefaults.synchronize()
        //let lastMyData: String? = userDefaults.object(forKey: "myData") as? String
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        
        //-----------------------------------------------------
        //----------------------------------------------------- firestore
        let dateData = [ "createAccount": dateStr, "clap": 3] as [String : Any]

        let teamData = ["belong": belongTo.text!, "kind": kindOfPerson.text!, "sports": teamSports.text!] as [String: Any]
        
        var _: DocumentReference? = nil
        
        db.collection("teams").document(teamID).setData(teamData)
        {
            err in
            if let err = err {
                print("失敗の場合\(teamID)")
                print("チーム情報登録でエラー")
            } else {
                print("成功の場合\(teamID)")
                print("チーム情報登録成功")
            }
        }
        //-----------------------------------------------------
        //選択式にすべき！！！！！！！
        //----------------------------------------------------- teamReplesentPage移動
        let teamPeplesentRegister = self.storyboard?.instantiateViewController(withIdentifier: "teamReplesentRegisterViewController") as! teamReplesentRegisterViewController
        self.present(teamPeplesentRegister, animated: true, completion: nil)
        //segueで繋いでいる理由は、視覚的にわかりやすくするため
        //-----------------------------------------------------


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
