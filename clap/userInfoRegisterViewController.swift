import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

//textfieldの下線追加
extension UITextField {
    func textBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
}

class userInfoRegisterViewController: UIViewController, UITextFieldDelegate{
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassAgain: UITextField!
    @IBOutlet weak var userRole: UITextField!
    @IBOutlet weak var userRegisterButton: UIButton!
    
    let userRoleData = ["選手", "監督", "マネージャー"]
    
    //userRole選択pickerviewでdone押して閉じる処理
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        if userRole.isFirstResponder {
            userRole.resignFirstResponder()
        }
    }
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //キーボードreturnでAction
        userName.delegate = self
        userEmail.delegate = self

        
        //placeholderの色変更、下線追加
        userName.attributedPlaceholder = NSAttributedString(string: "名前", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        userName.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
        
        userEmail.attributedPlaceholder = NSAttributedString(string: "メールアドレス", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        userEmail.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
        
        userPass.attributedPlaceholder = NSAttributedString(string: "パスワード", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        userPass.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
        
        userPassAgain.attributedPlaceholder = NSAttributedString(string: "パスワードの確認", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        userPassAgain.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
        
        userRole.attributedPlaceholder = NSAttributedString(string: "役割", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        userRole.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
        
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        userRegisterButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        userRegisterButton.backgroundColor = rgba // 背景色
        userRegisterButton.layer.cornerRadius = 20.0 // 角丸のサイズ
        userRegisterButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
        

        //キーボードreturnで次のtextfieldへ
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            
            if(textField == userName) {
                userEmail.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            
            return true
        }
//
//        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//            textField.resignFirstResponder()
//
//            if(textField == userName) {
//                userEmail.becomeFirstResponder()
//            } else {
//                textField.resignFirstResponder()
//            }
//
//            return true
//        }
        
        
        setupUI()
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
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
        
        DispatchQueue.global(qos: .default).async {
            Auth.auth().createUser(withEmail: self.userEmail.text!, password: self.userPass.text!) { (user, error) in
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
                        if user != nil {
                            print("ログインできました")
                            self.performSegue(withIdentifier: "schedule", sender: nil)
                            DispatchQueue.main.async {
                                //ログインしている現ユーザーUID取得
                                let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
                                let dateUnix: TimeInterval = Date().timeIntervalSince1970
                                let date = Date(timeIntervalSince1970: dateUnix)
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let dateStr: String = formatter.string(from: date) //現在時刻取得
                                let userDefaults:UserDefaults = UserDefaults.standard
                                let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
                                print("ユーザー登録画面のuserDefaults\(teamID)")
                                
                                let registerData = [
                                        "name": self.userName.text!,
                                        "role": self.userRole.text!,
                                        "createDate": dateStr,
                                        "teamID": teamID,
                                        "userID": fireAuthUID,
                                        "image": "https://firebasestorage.googleapis.com/v0/b/lily-ios-debug.appspot.com/o/profile%2FzUN6bPT6DwWyq1BIybPsDzE0fd52.jpeg?alt=media&token=c9682120-051f-4fac-9a31-81c077f2d08d"
                                    ] as [String: Any]
                                
                                let userRegistInfo = ["regist": true, "teamID": teamID] as [String : Any]
                                self.db.collection("teams").document(teamID).collection("users").document(fireAuthUID).setData(userRegistInfo)
                                {
                                    err in
                                    if let err = err {
                                        print("エラー \(err)")
                                    } else {
                                        print("ユーザー情報登録成功")
                                    }
                                }
                                self.db.collection("users").document(fireAuthUID).setData(registerData)
                                {
                                    err in
                                    if err != nil {
                                        print("ユーザー情報登録できません")
                                    } else {
                                        print("ユーザー情報登録成功")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    //キーボードhide処理
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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


private extension userInfoRegisterViewController {
    var accessoryToolbar: UIToolbar {
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
    
    func setupUI() {
        userRole.inputView = pickerView
        userRole.inputAccessoryView = accessoryToolbar
        userRole.text = userRoleData[0]
    }
}


extension userInfoRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return userRoleData.count
    }
    
    var pickerView: UIPickerView {
        get {
            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.backgroundColor = UIColor.white
            return pickerView
        }
    }
    
}


extension userInfoRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return userRoleData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        userRole.text = userRoleData[row]
    }
}


