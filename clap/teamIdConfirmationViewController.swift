import UIKit
import FirebaseFirestore
import FirebaseAuth


class teamIdConfirmationViewController: UIViewController {

    @IBOutlet weak var confirmTeamID: UITextField!
    @IBOutlet weak var confirmTeamIdButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ornemant()
    }
    
    @IBAction func confirmTreamIdButtonTapped(_ sender: Any) {
        confirm()
    }
    
    @IBAction func cancelbuttonTapped(_ sender: Any) {
        cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}




extension teamIdConfirmationViewController {
    func ornemant() {
        confirmTeamID.attributedPlaceholder = NSAttributedString(string: "チームID", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        confirmTeamID.tBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        confirmTeamIdButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        confirmTeamIdButton.backgroundColor = rgba
        confirmTeamIdButton.layer.cornerRadius = 20.0
        confirmTeamIdButton.setTitleColor(loginText, for: UIControlState.normal)
    }
    
    func confirm() {
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
                let againConfirm = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmAgainViewController") as! teamIdConfirmAgainViewController
                self.present(againConfirm, animated: true, completion: nil)
            } else {
                let wrongConfirm = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmWrongViewController") as! teamIdConfirmWrongViewController
                self.present(wrongConfirm, animated: true, completion: nil)
                
            }
        }
    }
    
    func cancel() {
        let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
    }
    
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
            print("tapped")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}




extension teamIdConfirmationViewController: UITextFieldDelegate {
    func basicInfo() {
        confirmTeamID.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}




extension UITextField {
    func tBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
}
