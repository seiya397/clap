import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class userInfoRegisterViewController: UIViewController{
    
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPass: UITextField!
    @IBOutlet weak var userPassAgain: UITextField!
    @IBOutlet weak var userRole: UITextField!
    
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func userRegisterButtonTapped(_ sender: Any) {
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
        
        DispatchQueue.global(qos: .default).async {
            Auth.auth().createUser(withEmail: self.userEmail.text!, password: self.userPass.text!) { (user, error) in
                if let error = error {
                    print("新規登録できませんでした")
                    print(error.localizedDescription)
                    self.ShowMessage(messageToDisplay: error.localizedDescription)
                    return
                } else {
                    print("新規登録成功しました")
                    //login
                    Auth.auth().signIn(withEmail: self.userEmail.text!, password: self.userPass.text!) { (user, error) in
                        if let error = error {
                            print(error.localizedDescription)
                            self.ShowMessage(messageToDisplay: error.localizedDescription)
                            return
                        }
                        if user != nil {
                            print("ログインできました")
                            self.performSegue(withIdentifier: "schedule", sender: nil)
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
                                print("ユーザー登録画面のuserDefaults\(teamID)")
                                
                                let registerData = [
                                        "name": self.userName.text!,
                                        "role": self.userRole.text!,
                                        "createDate": dateStr,
                                        "teamID": teamID,
                                        "image": "https://firebasestorage.googleapis.com/v0/b/lily-ios-debug.appspot.com/o/profile%2FzUN6bPT6DwWyq1BIybPsDzE0fd52.jpeg?alt=media&token=c9682120-051f-4fac-9a31-81c077f2d08d"
                                    ] as [String: Any]
                                
                                let userRegistInfo = ["regist": true, "teamID": teamID] as [String : Any]
                                self.db.collection("teams").document(teamID).collection("users").document(fireAuthUID).setData(userRegistInfo)
                                {
                                    err in
                                    if let err = err {
                                        print("エラー \(err)")
                                    } else {
                                        print("ユーザー情報登録成功")
                                    }
                                }
                                self.db.collection("users").document(fireAuthUID).setData(registerData)
                                {
                                    err in
                                    if err != nil {
                                        print("ユーザー情報登録できません")
                                    } else {
                                        print("ユーザー情報登録成功")
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    //認証用関数
    public func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "Alert Title", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "ok", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}
