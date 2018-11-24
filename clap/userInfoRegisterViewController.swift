import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


class userInfoRegisterViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassAgain: UITextField!
    @IBOutlet weak var userRole: UITextField!
    @IBOutlet weak var userRegisterButton: UIButton!
    
    let userRoleData = ["役割を選んでください","選手", "監督", "マネージャー"]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder(field: userName, string: "名前")
        placeholder(field: userEmail, string: "メールアドレス")
        placeholder(field: userPass, string: "パスワード")
        placeholder(field: userPassAgain, string: "パスワードの確認")
        placeholder(field: userRole, string: "役割")
        ornement()
        setupUI()
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
        confirm()
        registUserInfo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    @objc func onDoneButtonTapped(sender: UIBarButtonItem) {
        if userRole.isFirstResponder {
            userRole.resignFirstResponder()
        }
    }
    
    func setupUI() {
        userRole.inputView = pickerView
        userRole.inputAccessoryView = accessoryToolbar
        userRole.text = userRoleData[0]
    }
    
    func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func placeholder(field: UITextField, string: String) {
        field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        field.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func ornement() {
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        userRegisterButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        userRegisterButton.backgroundColor = rgba
        userRegisterButton.layer.cornerRadius = 20.0
        userRegisterButton.setTitleColor(loginText, for: UIControlState.normal)
    }
    
    func confirm() {
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
    }
    
    func registUserInfo() {
        DispatchQueue.global(qos: .default).async {
            Auth.auth().createUser(withEmail: self.userEmail.text!, password: self.userPass.text!) { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.ShowMessage(messageToDisplay: error.localizedDescription)
                    return
                } else {
                    Auth.auth().signIn(withEmail: self.userEmail.text!, password: self.userPass.text!) { (user, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            self.ShowMessage(messageToDisplay: error.localizedDescription)
                            return
                        }
                        if user != nil {
                            self.performSegue(withIdentifier: "schedule", sender: nil)
                            DispatchQueue.main.async {
                                let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
                                let dateUnix: TimeInterval = Date().timeIntervalSince1970
                                let date = Date(timeIntervalSince1970: dateUnix)
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let dateStr: String = formatter.string(from: date)
                                let userDefaults:UserDefaults = UserDefaults.standard
                                let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
                                
                                let registerData = [
                                    "name": self.userName.text!,
                                    "role": self.userRole.text!,
                                    "createDate": dateStr,
                                    "teamID": teamID,
                                    "userID": fireAuthUID,
                                    "image": "https://st3.depositphotos.com/7486768/17949/v/1600/depositphotos_179490486-stock-illustration-profile-anonymous-face-icon-gray.jpg"
                                    ] as [String: Any]
                                
                                let userRegistInfo = ["regist": true, "teamID": teamID] as [String : Any]
                                self.db.collection("teams").document(teamID).collection("users").document(fireAuthUID).setData(userRegistInfo)
                                {
                                    err in
                                    if let err = err {
                                        print("fail")
                                    } else {
                                        print("success")
                                    }
                                }
                                self.db.collection("users").document(fireAuthUID).setData(registerData)
                                {
                                    err in
                                    if err != nil {
                                        print("fail")
                                    } else {
                                        print("success")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}




extension userInfoRegisterViewController: UITextFieldDelegate {
    func basicInfo() {
        userName.delegate = self
        userEmail.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField == userName) {
            userEmail.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
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




extension UITextField {
    func textBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
