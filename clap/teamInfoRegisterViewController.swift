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
    
    var pickerView: UIPickerView {
        get {
            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.backgroundColor = UIColor.white
            return pickerView
        }
    }
    
    var pickerForAttribute = ["社会人", "大学", "高校", "中学"]
    
//    var pickerForSports = ["野球", "ラグビー", "柔道", "水泳", "サッカー"]
    
    var accessoryToolbarForAttribute: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTapped(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white
            return accessoryToolbar
        }
    }
    
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        if kindOfPerson.isFirstResponder {
            kindOfPerson.resignFirstResponder()
        }
    }
    
//    var accessoryToolbarForSports: UIToolbar {
//        get {
//            let toolbarFrame = CGRect(x: 0, y: 0,
//                                      width: view.frame.width, height: 44)
//            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
//            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
//                                             target: self,
//                                             action: #selector(onDoneButtonTappedForSports(sender:)))
//            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
//                                                target: nil,
//                                                action: nil)
//            accessoryToolbar.items = [flexibleSpace, doneButton]
//            accessoryToolbar.barTintColor = UIColor.white
//            return accessoryToolbar
//        }
//    }
//
//    @objc func onDoneButtonTappedForSports(sender: UIBarButtonItem) {
//        if teamSports.isFirstResponder {
//            teamSports.resignFirstResponder()
//        }
//    }
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
//        setupUIForSports()
    }
    
    func setupUI() {
        kindOfPerson.inputView = pickerView
        kindOfPerson.inputAccessoryView = accessoryToolbarForAttribute
        kindOfPerson.text = pickerForAttribute[0]
    }
    
//    func setupUIForSports() {
//        teamSports.inputView = pickerView
//        teamSports.inputAccessoryView = accessoryToolbarForSports
//        teamSports.text = pickerForSports[0]
//    }
    
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
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
        
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

extension teamInfoRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        
            return pickerForAttribute.count
        
    }
    
}


extension teamInfoRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        
            return pickerForAttribute[row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        
            return kindOfPerson.text = pickerForAttribute[row]
        
    }
}


