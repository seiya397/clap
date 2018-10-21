
import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseFirestore

class teamReplesentRegisterViewController: UIViewController {
    
    @IBOutlet weak var replesentName: UITextField!
    @IBOutlet weak var replesentEmail: UITextField!
    @IBOutlet weak var replesentPass: UITextField!
    @IBOutlet weak var replesentPassAgain: UITextField!
    @IBOutlet weak var replesentRole: UITextField!
    @IBOutlet weak var replesentGrade: UITextField!
    
    let db = Firestore.firestore()
    
    var pickerView: UIPickerView {
        get {
            let pickerView = UIPickerView()
            pickerView.dataSource = self
            pickerView.delegate = self
            pickerView.backgroundColor = UIColor.white
            return pickerView
        }
    }
    
    var pickerForRole = ["選手", "監督", "マネージャー"]
    
    //    var pickerForSports = ["野球", "ラグビー", "柔道", "水泳", "サッカー"]
    
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
        if replesentRole.isFirstResponder {
            replesentRole.resignFirstResponder()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        replesentRole.inputView = pickerView
        replesentRole.inputAccessoryView = accessoryToolbar
        replesentRole.text = pickerForRole[0]
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
}

extension teamReplesentRegisterViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return pickerForRole.count
    }
    
}


extension teamReplesentRegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        return pickerForRole[row]
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        replesentRole.text = pickerForRole[row]
    }
}
