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

//textfieldの下線追加
extension UITextField {
    func oBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
}

class teamInfoRegisterViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    enum PickerAttributeType {
        case career
        case sports
    }
    
    @IBOutlet weak var belongTo: UITextField!
    @IBOutlet weak var kindOfPerson: UITextField!
    @IBOutlet weak var teamSports: UITextField!
    @IBOutlet weak var managerRegister: UIButton!
    
    
    var pickerForAttribute = ["社会人", "大学", "高校", "中学"]
    var pickerForSports = ["野球", "ラグビー", "柔道", "水泳", "サッカー"]
    
    let db = Firestore.firestore()
    
    @objc func onDoneButtonTappedForCareer(sender: UIBarButtonItem) {
        if kindOfPerson.isFirstResponder {
            kindOfPerson.resignFirstResponder()
        }
    }
    
    @objc func onDoneButtonTappedForSports(sender: UIBarButtonItem) {
        if teamSports.isFirstResponder {
            teamSports.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholderの色変更、下線追加
        belongTo.attributedPlaceholder = NSAttributedString(string: "チーム名", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        kindOfPerson.attributedPlaceholder = NSAttributedString(string: "学年", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        teamSports.attributedPlaceholder = NSAttributedString(string: "競技", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        belongTo.oBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        kindOfPerson.oBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        teamSports.oBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        managerRegister.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        managerRegister.backgroundColor = rgba // 背景色
        managerRegister.layer.cornerRadius = 22.0 // 角丸のサイズ
        managerRegister.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
        
        setupUI()
        setupUIForSports()
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
        
        let userDefaults:UserDefaults = UserDefaults.standard
        let randomStringToTeamID = self.randomString(length: 20)
        userDefaults.set(randomStringToTeamID, forKey: "teamID")
        userDefaults.synchronize()
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        
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
        let teamPeplesentRegister = self.storyboard?.instantiateViewController(withIdentifier: "teamReplesentRegisterViewController") as! teamReplesentRegisterViewController
        self.present(teamPeplesentRegister, animated: true, completion: nil)
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
    
    //キーボードhide処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

//pickerviewツールバー

private extension teamInfoRegisterViewController {
    var accessoryToolbarForCareer: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTappedForCareer(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.black.withAlphaComponent(0.2)
            return accessoryToolbar
        }
    }
    
    var accessoryToolbarForSports: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTappedForSports(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.black.withAlphaComponent(0.2)
            return accessoryToolbar
        }
    }
    
    func setupUI() {
        kindOfPerson.inputView = getPickerView(type: .career)
        kindOfPerson.inputAccessoryView = accessoryToolbarForCareer
        kindOfPerson.text = pickerForAttribute[0]
    }

    func setupUIForSports() {
        teamSports.inputView = getPickerView(type: .sports)
        teamSports.inputAccessoryView = accessoryToolbarForSports
        teamSports.text = pickerForSports[0]
    }
    
    //pickerview本体
    func getPickerView(type: PickerAttributeType) -> UIPickerView {
        var pickerView = UIPickerView()
        switch type {
        case .career:
            pickerView = CareerPickerView()
        case .sports:
            pickerView = SportsPickerView()
        }
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        return pickerView
    }
}


fileprivate class CareerPickerView: UIPickerView {}
fileprivate class SportsPickerView: UIPickerView {}


extension teamInfoRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case is CareerPickerView:
            return pickerForAttribute.count
        case is SportsPickerView:
            return pickerForSports.count
        default:
            return pickerForAttribute.count
        }
    }
}


extension teamInfoRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch pickerView {
        case is CareerPickerView:
            return pickerForAttribute[row]
        case is SportsPickerView:
            return pickerForSports[row]
        default:
            return pickerForAttribute[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch pickerView {
        case is CareerPickerView:
            return kindOfPerson.text = pickerForAttribute[row]
        case is SportsPickerView:
            return teamSports.text = pickerForSports[row]
        default:
            return kindOfPerson.text = pickerForAttribute[row]
        }
    }
}


