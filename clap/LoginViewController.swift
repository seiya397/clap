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

class LoginViewController: UIViewController {
    

    @IBOutlet weak var commonMailaddress: UITextField!
    @IBOutlet weak var commonPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholderの色変更、下線追加
        commonMailaddress.attributedPlaceholder = NSAttributedString(string: "メールアドレス", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        commonPassword.attributedPlaceholder = NSAttributedString(string: "パスワード", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        commonMailaddress.addBorderBottom(height: 1.0, color: UIColor.white)
        commonPassword.addBorderBottom(height: 1.0, color: UIColor.white)
        
        // ボタンの装飾
        let rgba = UIColor(red: 254/255, green: 238/255, blue: 38/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 191/255, green: 189/255, blue: 192/255, alpha: 1.0) // ボタンテキスト色設定
        loginButton.backgroundColor = rgba // 背景色
        loginButton.layer.cornerRadius = 15.0 // 角丸のサイズ
        loginButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
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
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {//新規登録
        let selectPage = self.storyboard?.instantiateViewController(withIdentifier: "topSelectPageViewController") as! topSelectPageViewController
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
    
}
