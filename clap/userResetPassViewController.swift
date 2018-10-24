import UIKit
import FirebaseAuth



//textfieldの下線追加
extension UITextField {
    func plusBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}


class userResetPassViewController: UIViewController {

    @IBOutlet weak var userEmailForResetPass: UITextField!
    @IBOutlet weak var renewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //placeholderの色変更、下線追加
        userEmailForResetPass.attributedPlaceholder = NSAttributedString(string: "endo@clap.com", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        userEmailForResetPass.addBorderBottom(height: 1.0, color: UIColor.white)
        
        // 更新ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 212/255, blue: 24/255, alpha: 1.0) // ボタン背景色設定
        let renewText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        renewButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        renewButton.backgroundColor = rgba // 背景色
        renewButton.layer.cornerRadius = 15.0 // 角丸のサイズ
        renewButton.setTitleColor(renewText, for: UIControlState.normal) // タイトルの色
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resetPassButtonTapped(_ sender: Any) {//resetButton
        guard let userEmailAddress = userEmailForResetPass.text, !userEmailAddress.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        
        Auth.auth().sendPasswordReset(withEmail: userEmailAddress) { (error) in
            if error != nil {
                self.ShowMessage(messageToDisplay: (error?.localizedDescription)!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func usercancelButtonTapped(_ sender: Any) {//cancelButton
        self.dismiss(animated: true, completion: nil)
    }
    
    public func ShowMessage(messageToDisplay: String) {//確認用
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
