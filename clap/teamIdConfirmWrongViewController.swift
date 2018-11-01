//
//  teamIdConfirmWrongViewController.swift
//  clap
//
//  Created by オムラユウキ on 2018/09/15.
//  Copyright © 2018年 Seiya. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

//textfieldの下線追加
extension UITextField {
    func idBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}

class teamIdConfirmWrongViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var confirmTextAgain: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholderの色変更、下線追加
        confirmTextAgain.attributedPlaceholder = NSAttributedString(string: "チームID", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        confirmTextAgain.tBorderBottom(height: 0.5, color: UIColor.white)
        
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        confirmButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        confirmButton.backgroundColor = rgba // 背景色
        confirmButton.layer.cornerRadius = 20.0 // 角丸のサイズ
        confirmButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
        
    }
        // Do any additional setup after loading the view.
    
    //キーボードdoneでhide処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        guard  let confirmText = confirmTextAgain.text, !confirmText.isEmpty else {
            self.ShowMessage(messageToDisplay: "チームIDを記入してください。")
            return
        }
        
        let docRef = db.collection("teams").document(confirmTextAgain.text!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userDefaults: UserDefaults = UserDefaults.standard
                let teamIdByWritten = self.confirmTextAgain.text!
                userDefaults.set(teamIdByWritten, forKey: "teamID")
                userDefaults.synchronize()
//                let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
//                print(teamID)
                let userInfoRegisterPage = self.storyboard?.instantiateViewController(withIdentifier: "userInfoRegisterViewController") as! userInfoRegisterViewController
                self.present(userInfoRegisterPage, animated: true, completion: nil)
            } else {
                let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginPage, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
    
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
