import UIKit
import FirebaseFirestore
import FirebaseAuth


class teamIdConfirmWrongViewController: UIViewController  {

    @IBOutlet weak var confirmTextAgain: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ornement()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        confirm()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




extension teamIdConfirmWrongViewController {
    func ornement() {
        confirmTextAgain.attributedPlaceholder = NSAttributedString(string: "チームID", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        
        confirmTextAgain.tBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        confirmButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        confirmButton.backgroundColor = rgba
        confirmButton.layer.cornerRadius = 20.0
        confirmButton.setTitleColor(loginText, for: UIControlState.normal)
        
    }
    
    func confirm() {
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
                let userInfoRegisterPage = self.storyboard?.instantiateViewController(withIdentifier: "userInfoRegisterViewController") as! userInfoRegisterViewController
                self.present(userInfoRegisterPage, animated: true, completion: nil)
            } else {
                let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginPage, animated: true, completion: nil)
            }
        }
    }
    
    func cancel() {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
        
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




extension teamIdConfirmWrongViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}




extension UITextField {
    func idBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
