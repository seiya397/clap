import UIKit
import Firebase
import FirebaseAuth


//textfieldの下線追加
extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
}

class LoginViewController: UIViewController, UITextFieldDelegate{
    

    @IBOutlet weak var commonMailaddress: UITextField!
    @IBOutlet weak var commonPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //キーボードreturnでAction
        commonMailaddress.delegate = self
        commonPassword.delegate = self
        
        self.view.backgroundColor = UIColor.lightGray
        
        //placeholderの色変更、下線追加
        commonMailaddress.attributedPlaceholder = NSAttributedString(string: "メールアドレス", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        commonPassword.attributedPlaceholder = NSAttributedString(string: "パスワード", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        commonMailaddress.addBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        commonPassword.addBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        loginButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        loginButton.backgroundColor = rgba // 背景色
        loginButton.layer.cornerRadius = 22.0 // 角丸のサイズ
        loginButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
    }
    
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    //キーボードreturnで次のtextfieldへ
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField == commonMailaddress) {
            commonPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func commonLoginButton(_ sender: Any) {//ログイン
        guard let userEmailText = commonMailaddress.text, !userEmailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let userPassText = commonPassword.text, !userPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        Auth.auth().signIn(withEmail: commonMailaddress.text!, password: commonPassword.text!) { (user, error) in
            if let error = error {
                self.ShowMessage(messageToDisplay: "ログイン出来ません")
                print("ログイン出来ひん！！！！！")
                return
            } else if let user = user {
                print("ログインできました。\(user)")
//                self.performSegue(withIdentifier: "aaaaa", sender: nil)
                    let mainPage = self.storyboard?.instantiateViewController(withIdentifier: "navi")
                    self.present(mainPage!, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
        
        //新規登録
        let selectPage = self.storyboard?.instantiateViewController(withIdentifier: "topSelectPageViewController") as! topSelectPageViewController
        
        //ボタン押すとアニメーション発動
        selectPage.modalTransitionStyle  = .crossDissolve
        self.present(selectPage, animated: true, completion: nil)
        
    }
    
    //segueで繋いでいる理由は、視覚的にわかりやすくするため
    
    @IBAction func resetPassButtontapped(_ sender: Any) {//パスワード忘れた人
    }
    
    public func ShowMessage(messageToDisplay: String) { //確認用
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
