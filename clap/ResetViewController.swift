import UIKit
import FirebaseAuth


class ResetViewController: UIViewController {
    
    @IBOutlet weak var emailForResetPass: UITextField!
    @IBOutlet weak var renewButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicInfo()
        ornemant()
    }
    
    
    @IBAction func resetTapped(_ sender: Any) {
        resetPass()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




extension ResetViewController {
    func ornemant() {
        emailForResetPass.attributedPlaceholder = NSAttributedString(string: "endo@clap.com", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        emailForResetPass.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))

        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let renewText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        renewButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        renewButton.backgroundColor = rgba
        renewButton.layer.cornerRadius = 22.0
        renewButton.setTitleColor(renewText, for: UIControlState.normal)
    }
    
    func resetPass() {
        guard let userEmailAddress = emailForResetPass.text, !userEmailAddress.isEmpty else {
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
    
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}




extension ResetViewController: UITextFieldDelegate {
    func basicInfo() {
        emailForResetPass.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


extension UITextField {
    func plusBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
