import UIKit
import FirebaseFirestore
import FirebaseAuth

class myPageViewController: UIViewController {
    
    @IBOutlet weak var teamName: UILabel!
    @IBOutlet weak var teamIDLabel: UILabel!
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        print("今度こそ\(fireAuthUID)")
        
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!//teamID取得
        db.collection("teams").document(teamID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("error \(error)")
                return
            }
            let data = document.data()
            print("このデータは \(data!["belong"])")
            self.teamName.text = data!["belong"] as? String
        }
        
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                print("erorr2 \(error)")
                return
            }
            let data = document2.data()
            print("この名前は \(data!["name"])")//登録で一つ前のユーザーUID取得して登録しているはずなのに、マイページではしっかりと現在のユーザーUIDを取得してpathに当てはめてるから、ないpathのデータを取りに行こうとしてdataには値は何も入らない現象になる
            //前回のユーザーアドレスでログインしても、その次に登録したユーザーUIDが取れてしまう
            //userdefaults 登録じに記憶した値を取得するから、その時に
            //また前回のユーザーを指定してログインするとしっかりとそのユーザーのデータが取れるから問題なし。
            self.teamIDLabel.text = data!["name"] as? String
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
}
