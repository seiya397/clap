
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        //--------------------------------------- fireAuth
        
        //logout
        do {
            try Auth.auth().signOut()
            //createUser
            Auth.auth().createUser(withEmail: replesentEmail.text!, password: replesentPass.text!) { (user, error) in
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
                        if let user = user {
                            print("ログインできました")

                        }
                    }
                }
            }
        } catch {
            print("ログアウトできませんでした")
        }
        
        //ログインしている現ユーザーUID取得
        //ログインの前に先にこれが処理されて、うまく動作しない
        //ログアウトしてこのページではno data だが、mypageではしっかりとcurrentUserのUID取得できている。よって問題点は、処理の順番になる。
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        
        print("今度こそ\(fireAuthUID)")
        
        //--------------------------------------- fireAuth
        //--------------------------------------- createDate
        let dateUnix: TimeInterval = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: dateUnix)
        // NSDate型を日時文字列に変換するためのNSDateFormatterを生成
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // NSDateFormatterを使ってNSDate型 "date" を日時文字列 "dateStr" に変換
        let dateStr: String = formatter.string(from: date) //現在時刻取得
        //--------------------------------------- createDate
        //--------------------------------------- fireStore
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        
        let replesentData = ["name": replesentName.text!, "role": replesentRole.text!, "grade": replesentGrade.text!, "createDate": dateStr] as [String: Any]
        let userRegistInfo = ["regist": true, "teamID": teamID] as [String : Any]
        let teamRegisterData = ["regist": true] as [String: Any]
        var _: DocumentReference? = nil
        db.collection("teams").document(teamID).collection("users").document(fireAuthUID).setData(userRegistInfo)
        {
            err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID")
            }
        }
       
        db.collection("users").document(fireAuthUID).setData(replesentData)
        {
            err in
            if let err2 = err {
                print("can not regist user infomation")
            } else {
                print(" ")
            }
        }
        //--------------------------------------- fireStore
        //--------------------------------------- 移動
        let teamIdGenerationPage = self.storyboard?.instantiateViewController(withIdentifier: "teamIdGenerateViewController") as! teamIdGenerateViewController
        self.present(teamIdGenerationPage, animated: true, completion: nil)
        //segueで繋いでいる理由は、視覚的にわかりやすくするため
        //--------------------------------------- 移動
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
