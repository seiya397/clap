import UIKit
import FirebaseFirestore
import FirebaseAuth

class myPageViewController: UIViewController{
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userRole: UILabel!
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamIDLabel: UILabel!
    
    var item = String()
    var add = UILabel()
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        print("今度こそ\(fireAuthUID)")
        
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        self.teamIDLabel.text = teamID //チームID表示
        
        db.collection("teams").document(teamID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("error \(error)")
                return
            }
            let data = document.data()
            print("このデータは \(data!["belong"])")
            self.teamName.text = data!["belong"] as? String //チーム名表示
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                print("erorr2 \(error)")
                return
            }
            let data = document2.data()
            print("この名前は \(data!["name"])")
            self.userName.text = data!["name"] as? String //ユーザー名表示
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print("erorr2 \(error)")
                return
            }
            let data = document3.data()
            print("この名前は \(data!["role"])")
            self.userRole.text = data!["role"] as? String //ユーザー名表示
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func logoutButton(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            print("ログアウトできました")
            let fireAuthUID2 = (Auth.auth().currentUser?.uid ?? "no data")
            print("ログアウト後\(fireAuthUID2)")
            let loginPage = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.present(loginPage, animated: true, completion: nil)
        } catch {
            print("ログアウトできませんでした")
        }
    }
    
    @IBAction func cahngeInfoButtonTapped(_ sender: Any) {
        alert()
    }
    
    func alert() {
        let alert = UIAlertController(title: "名前変更", message: "メッセージ", preferredStyle: .alert)
        
        // OKボタンの設定
        let okAction = UIAlertAction(title: "保存", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            
            // OKを押した時入力されていたテキストを表示
            if let textFields = alert.textFields {
                
                // アラートに含まれるすべてのテキストフィールドを調べる
                for textField in textFields {
                    self.userName.text = textField.text!
                    
                    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
                    self.db.collection("users").document(fireAuthUID).updateData(["name": (self.userName.text)!])
                    
                    print(textField.text!)
                }
            }
        })
        
        alert.addAction(okAction)
        
        // キャンセルボタンの設定
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        // テキストフィールドを追加
        alert.addTextField(configurationHandler: {(textField: UITextField!) -> Void in
            textField.placeholder = "テキスト"
        })
        
        alert.view.setNeedsLayout() // シミュレータの種類によっては、これがないと警告が発生
        
        // アラートを画面に表示
        self.present(alert, animated: true, completion: nil)

    }
}
