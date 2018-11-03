import UIKit
import FirebaseFirestore

class teamIdConfirmAgainViewController: UIViewController {

    @IBOutlet weak var displayTeamName: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults: UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
        
        db.collection("teams").document(teamID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("error \(error)")
                return
            }
            let data = document.data()
            print("this data \(data!["belong"])")
            self.displayTeamName.text = data!["belong"] as? String
        }
        //userDefaultsからひっぱてきてpathに通して、チームめいをひっぱてくる
    
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        confirmButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        confirmButton.backgroundColor = rgba // 背景色
        confirmButton.layer.cornerRadius = 20.0 // 角丸のサイズ
        confirmButton.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        let userInfoRegisterPage2 = self.storyboard?.instantiateViewController(withIdentifier: "userInfoRegisterViewController") as! userInfoRegisterViewController
        self.present(userInfoRegisterPage2, animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        let loginPage2 = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage2, animated: true, completion: nil)
    }
}
