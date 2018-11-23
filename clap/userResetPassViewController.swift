import UIKit
import FirebaseAuth



class UserResetPassViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userEmailForResetPass: UITextField!
    @IBOutlet weak var renewButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userEmailForResetPass.delegate = self
        
        userEmailForResetPass.attributedPlaceholder = NSAttributedString(string: "endo@clap.com", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        userEmailForResetPass.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
        
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let renewText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        renewButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        renewButton.backgroundColor = rgba
        renewButton.layer.cornerRadius = 22.0
        renewButton.setTitleColor(renewText, for: UIControlState.normal)
        

    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func resetPassButtonTapped(_ sender: Any) {
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
    
    @IBAction func usercancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}


private extension userResetPassViewController {
    func ornemant() {
        
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
