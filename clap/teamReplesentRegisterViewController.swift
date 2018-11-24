
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

enum pickerViewAttribute {
    case Role
    case Grade
}

class teamReplesentRegisterViewController: UIViewController {
    
    @IBOutlet weak var replesentName: UITextField!
    @IBOutlet weak var replesentEmail: UITextField!
    @IBOutlet weak var replesentPass: UITextField!
    @IBOutlet weak var replesentPassAgain: UITextField!
    @IBOutlet weak var replesentRole: UITextField!
    @IBOutlet weak var replesentGrade: UITextField!
    @IBOutlet weak var replesentInfoResisterButton: UIButton!
    
    let db = Firestore.firestore()
    
    var pickerForRole = ["役割を選んでください","選手", "監督", "マネージャー"]
    var pickerForGrade = [ "学年を選んでください", "1年生", "2年生", "3年生", "4年生"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeholder(field: replesentName, string: "名前")
        placeholder(field: replesentEmail, string: "メールアドレス")
        placeholder(field: replesentPass, string: "パスワード")
        placeholder(field: replesentPassAgain, string: "パスワードの確認")
        placeholder(field: replesentRole, string: "役割")
        placeholder(field: replesentGrade, string: "学年")
        
        borderOnement(field: replesentName)
        borderOnement(field: replesentEmail)
        borderOnement(field: replesentPass)
        borderOnement(field: replesentPassAgain)
        borderOnement(field: replesentRole)
        borderOnement(field: replesentGrade)
        
        ornement()
        setupUIForRole()
        setupUIForGrade()
    }
    
    @IBAction func replesentInfoRegisterButtonTapped(_ sender: Any) {
        confirm()
        regist()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}




private extension teamReplesentRegisterViewController {
    var accessoryToolbarForRole: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTappedForRole(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white
            return accessoryToolbar
        }
    }
    
    @objc func onDoneButtonTappedForRole(sender: UIBarButtonItem) {
        if replesentRole.isFirstResponder {
            replesentRole.resignFirstResponder()
        }
    }
    
    var accessoryToolbarForGrade: UIToolbar {
        get {
            let toolbarFrame = CGRect(x: 0, y: 0,
                                      width: view.frame.width, height: 44)
            let accessoryToolbar = UIToolbar(frame: toolbarFrame)
            let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
                                             target: self,
                                             action: #selector(onDoneButtonTappedForGrade(sender:)))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                                target: nil,
                                                action: nil)
            accessoryToolbar.items = [flexibleSpace, doneButton]
            accessoryToolbar.barTintColor = UIColor.white
            return accessoryToolbar
        }
    }
    
    @objc func onDoneButtonTappedForGrade(sender: UIBarButtonItem) {
        if replesentGrade.isFirstResponder {
            replesentGrade.resignFirstResponder()
        }
    }
    
    func setupUIForRole() {
        replesentRole.inputView = getPickerView(type: .Role)
        replesentRole.inputAccessoryView = accessoryToolbarForRole
        replesentRole.text = pickerForRole[0]
    }
    
    func setupUIForGrade() {
        replesentGrade.inputView = getPickerView(type: .Grade)
        replesentGrade.inputAccessoryView = accessoryToolbarForGrade
        replesentGrade.text = pickerForGrade[0]
    }
    
    func getPickerView(type: pickerViewAttribute) -> UIPickerView {
        var pickerView = UIPickerView()
        switch type {
        case .Role:
            pickerView = RolePickerView()
        case .Grade:
            pickerView = GradePickerView()
        }
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.backgroundColor = UIColor.white
        return pickerView
    }
    
    func placeholder(field: UITextField, string: String) {
        field.attributedPlaceholder = NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        field.addBorderBottom(height: 1.0, color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func borderOnement(field: UITextField) {
        field.oBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
    }
    
    func ornement() {
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        replesentInfoResisterButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        replesentInfoResisterButton.backgroundColor = rgba
        replesentInfoResisterButton.layer.cornerRadius = 22.0
        replesentInfoResisterButton.setTitleColor(loginText, for: UIControlState.normal)
    }
    
    func confirm() {
        guard let nameText = replesentName.text, !nameText.isEmpty else {
            self.ShowMessage(messageToDisplay: "名前を記入してください。")
            return
        }
        guard let mailText = replesentEmail.text, !mailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let passText = replesentPass.text, !passText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        guard let passTextAgain = replesentPassAgain.text, !passTextAgain.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        guard let roleText = replesentRole.text, !roleText.isEmpty else {
            self.ShowMessage(messageToDisplay: "役割を記入してください。")
            return
        }
        guard let gradeText = replesentGrade.text, !gradeText.isEmpty else {
            self.ShowMessage(messageToDisplay: "学年を記入してください。")
            return
        }
    }
    
    func regist() {
        DispatchQueue.global(qos: .default).async {
            Auth.auth().createUser(withEmail: self.replesentEmail.text!, password: self.replesentPass.text!) { (user, error) in
                if let error = error {
                    print("新規登録できませんでした")
                    self.ShowMessage(messageToDisplay: error.localizedDescription)
                    return
                }
                if user != nil {
                    print("新規登録できました")
                    Auth.auth().signIn(withEmail: self.replesentEmail.text!, password: self.replesentPass.text!) { (user, error) in
                        if let error = error {
                            print("ログインに失敗しました")
                            self.ShowMessage(messageToDisplay: error.localizedDescription)
                            return
                        }
                        if user != nil {
                            print("ログインできました")
                            DispatchQueue.main.async {
                                let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
                                
                                let dateUnix: TimeInterval = Date().timeIntervalSince1970
                                let date = Date(timeIntervalSince1970: dateUnix)
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                let dateStr: String = formatter.string(from: date)
                                let userDefaults:UserDefaults = UserDefaults.standard
                                let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
                                let replesentData = [
                                    "name": self.replesentName.text!,
                                    "role": self.replesentRole.text!,
                                    "grade": self.replesentGrade.text!,
                                    "createDate": dateStr,
                                    "teamID": teamID,
                                    "userID": fireAuthUID,
                                    "image": "https://st3.depositphotos.com/7486768/17949/v/1600/depositphotos_179490486-stock-illustration-profile-anonymous-face-icon-gray.jpg"
                                    ] as [String: String]
                                
                                let userRegistInfo = ["regist": true, "teamID": teamID] as [String : Any]
                                self.db.collection("teams").document(teamID).collection("users").document(fireAuthUID).setData(userRegistInfo)
                                {
                                    err in
                                    if let err = err {
                                        print("Error adding document: \(err)")
                                    } else {
                                        print("Document added with ID")
                                    }
                                }
                                
                                self.db.collection("users").document(fireAuthUID).setData(replesentData)
                                {
                                    err in
                                    if err != nil {
                                        print("can not regist user infomation")
                                    } else {
                                        print(" ")
                                    }
                                }
                                
                                let teamIdGenerationPage = self.storyboard?.instantiateViewController(withIdentifier: "teamIdGenerateViewController") as! teamIdGenerateViewController
                                self.present(teamIdGenerationPage, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}




fileprivate class RolePickerView: UIPickerView {}
fileprivate class GradePickerView: UIPickerView {}




extension teamReplesentRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case is RolePickerView:
            return pickerForRole.count
        case is GradePickerView:
            return pickerForGrade.count
        default:
            return pickerForRole.count
        }
    }
    
}




extension teamReplesentRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        switch pickerView {
        case is RolePickerView:
            return pickerForRole[row]
        case is GradePickerView:
            return pickerForGrade[row]
        default:
            return pickerForRole[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        switch pickerView {
        case is RolePickerView:
            return replesentRole.text = pickerForRole[row]
        case is GradePickerView:
            return replesentGrade.text = pickerForGrade[row]
        default:
            return replesentRole.text = pickerForRole[row]
        }
    }
}




extension UITextField {
    func trBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
