import UIKit
import Firebase
import FirebaseAuth


class LoginViewController: UIViewController {

    @IBOutlet weak var commonMailaddress: UITextField!
    @IBOutlet weak var commonPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicInfo()
        ornemant()
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    @IBAction func commonLoginButton(_ sender: Any) {
        loginContent()
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
        topPageSegue()
    }
    
    @IBAction func resetPassButtontapped(_ sender: Any) {
        resetPageSegue()
    }
}


extension LoginViewController: UITextFieldDelegate {
    func basicInfo() {
        commonMailaddress.delegate = self
        commonPassword.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField == commonMailaddress) {
            commonPassword.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
}


extension LoginViewController {
    
    func topPageSegue() {
        let selectPage = self.storyboard?.instantiateViewController(withIdentifier: "topSelectPageViewController") as! topSelectPageViewController
        
        selectPage.modalTransitionStyle  = .crossDissolve
        self.present(selectPage, animated: true, completion: nil)
    }
    
    func resetPageSegue() {
        let selectPage = self.storyboard?.instantiateViewController(withIdentifier: "UserResetPassViewController") as! UserResetPassViewController
        
        selectPage.modalTransitionStyle  = .crossDissolve
        self.present(selectPage, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    private func ornemant() {
        commonMailaddress.attributedPlaceholder = NSAttributedString(string: "メールアドレス", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        commonPassword.attributedPlaceholder = NSAttributedString(string: "パスワード", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        commonMailaddress.addBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        commonPassword.addBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        loginButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        loginButton.backgroundColor = rgba
        loginButton.layer.cornerRadius = 22.0
        loginButton.setTitleColor(loginText, for: UIControlState.normal)
    }
    
    func loginContent() {
        guard let userEmailText = commonMailaddress.text, !userEmailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let userPassText = commonPassword.text, !userPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        Auth.auth().signIn(withEmail: commonMailaddress.text!, password: commonPassword.text!) { (user, error) in
            if error != nil {
                self.ShowMessage(messageToDisplay: "ログイン出来ません")
                
                return
            } else if user != nil {
                
                let mainPage = self.storyboard?.instantiateViewController(withIdentifier: "navi")
                self.present(mainPage!, animated: true, completion: nil)
            }
        }
    }
    
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}


extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
