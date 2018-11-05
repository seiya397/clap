
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

//textfieldの下線追加
extension UITextField {
    func trBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
    
}

class teamReplesentRegisterViewController: UIViewController {
    enum pickerViewAttribute {
        case Role
        case Grade
    }
    
    @IBOutlet weak var replesentName: UITextField!
    @IBOutlet weak var replesentEmail: UITextField!
    @IBOutlet weak var replesentPass: UITextField!
    @IBOutlet weak var replesentPassAgain: UITextField!
    @IBOutlet weak var replesentRole: UITextField!
    @IBOutlet weak var replesentGrade: UITextField!
    @IBOutlet weak var replesentInfoResisterButton: UIButton!
    
    let db = Firestore.firestore()
    
    var pickerForRole = ["選手", "監督", "マネージャー"]
    var pickerForGrade = [ "--", "1年生", "2年生", "3年生", "4年生"]
    
    
    @objc func onDoneButtonTappedForRole(sender: UIBarButtonItem) {
        if replesentRole.isFirstResponder {
            replesentRole.resignFirstResponder()
        }
    }
    
    @objc func onDoneButtonTappedForGrade(sender: UIBarButtonItem) {
        if replesentGrade.isFirstResponder {
            replesentGrade.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //placeholderの色変更、下線追加
        replesentName.attributedPlaceholder = NSAttributedString(string: "名前", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        replesentEmail.attributedPlaceholder = NSAttributedString(string: "メールアドレス", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        replesentPass.attributedPlaceholder = NSAttributedString(string: "パスワード", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        replesentPassAgain.attributedPlaceholder = NSAttributedString(string: "パスワードの確認", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        replesentRole.attributedPlaceholder = NSAttributedString(string: "役割", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        replesentGrade.attributedPlaceholder = NSAttributedString(string: "学年", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5)])
        
        replesentName.trBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        replesentEmail.trBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        replesentPass.trBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        replesentPassAgain.trBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        replesentRole.trBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        replesentGrade.trBorderBottom(height: 0.5, color: UIColor.white.withAlphaComponent(0.5))
        
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        replesentInfoResisterButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        replesentInfoResisterButton.backgroundColor = rgba // 背景色
        replesentInfoResisterButton.layer.cornerRadius = 22.0 // 角丸のサイズ
        replesentInfoResisterButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
        
        
        
        setupUIForRole()
        setupUIForGrade()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func replesentInfoRegisterButtonTapped(_ sender: Any) {
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
        
        DispatchQueue.global(qos: .default).async {
            //createUser
            Auth.auth().createUser(withEmail: self.replesentEmail.text!, password: self.replesentPass.text!) { (user, error) in
                if let error = error {
                    print("新規登録できませんでした")
                    self.ShowMessage(messageToDisplay: error.localizedDescription)
                    return
                }
                if user != nil {
                    print("新規登録できました")
                    
                    //login
                    Auth.auth().signIn(withEmail: self.replesentEmail.text!, password: self.replesentPass.text!) { (user, error) in
                        if let error = error {
                            print("ログインに失敗しました")
                            self.ShowMessage(messageToDisplay: error.localizedDescription)
                            return
                        }
                        if user != nil {
                            print("ログインできました")
                            DispatchQueue.main.async {
                                //ログインしている現ユーザーUID取得
                                let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
                                
                                let dateUnix: TimeInterval = Date().timeIntervalSince1970
                                let date = Date(timeIntervalSince1970: dateUnix)
                                
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                
                                let dateStr: String = formatter.string(from: date) //現在時刻取得
                                let userDefaults:UserDefaults = UserDefaults.standard
                                let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
                                
                                let replesentData = [
                                    "name": self.replesentName.text!,
                                     "role": self.replesentRole.text!,
                                     "grade": self.replesentGrade.text!,
                                     "createDate": dateStr,
                                     "teamID": teamID,
                                     "userID": fireAuthUID,
                                     "image": "https:firebasestorage.googleapis.com/v0/b/lily-ios-debug.appspot.com/o/profile%2FzUN6bPT6DwWyq1BIybPsDzE0fd52.jpeg?alt=media&token=c9682120-051f-4fac-9a31-81c077f2d08d"
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
