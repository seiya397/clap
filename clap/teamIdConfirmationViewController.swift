import UIKit
import FirebaseFirestore
import FirebaseAuth

//textfieldの下線追加
extension UITextField {
    func tBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
}

class teamIdConfirmationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var confirmTeamID: UITextField!
    @IBOutlet weak var confirmTeamIdButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //キーボードreturnでAction
        confirmTeamID.delegate = self
        
    //placeholderの色変更、下線追加
    confirmTeamID.attributedPlaceholder = NSAttributedString(string: "チームID", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])

    confirmTeamID.tBorderBottom(height: 0.5, color: UIColor.white)
        
    // ボタンの装飾
    let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
    let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
    confirmTeamIdButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
    confirmTeamIdButton.backgroundColor = rgba // 背景色
    confirmTeamIdButton.layer.cornerRadius = 20.0 // 角丸のサイズ
    confirmTeamIdButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
        
    }
    
    //キーボードdoneでhide処理
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    @IBAction func confirmTreamIdButtonTapped(_ sender: Any) {
        guard let confirmText = confirmTeamID.text, !confirmText.isEmpty else {
            self.ShowMessage(messageToDisplay: "チームIDを記入してください。")
            return
        }
        
        let userDefaults:UserDefaults = UserDefaults.standard
        
        let teamIdByWritten = confirmTeamID.text
        
        userDefaults.set(teamIdByWritten, forKey: "teamID")
        
        userDefaults.synchronize()
        
        let docRef = db.collection("teams").document(confirmTeamID.text!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("成功した場合\(document)")
                let againConfirm = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmAgainViewController") as! teamIdConfirmAgainViewController
                self.present(againConfirm, animated: true, completion: nil)
            } else {
                print("失敗した場合\(String(describing: error))")
                let wrongConfirm = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmWrongViewController") as! teamIdConfirmWrongViewController
                self.present(wrongConfirm, animated: true, completion: nil)
                
            }
        }
    }
    
    @IBAction func cancelbuttonTapped(_ sender: Any) {
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
