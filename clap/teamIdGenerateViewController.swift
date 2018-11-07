import UIKit
import Firebase
import FirebaseDatabase

class teamIdGenerateViewController: UIViewController {

    @IBOutlet weak var generateTeamId: UILabel!
    @IBOutlet weak var goLogin: UIButton!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = userDefaults.object(forKey: "teamID") as! String
        self.generateTeamId.text! = teamID
        
        // ボタンの装飾
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0) // ボタン背景色設定
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0) // ボタンタイトル色設定
        goLogin.frame = CGRect(x: 0, y: 0, width: 0, height: 46) //ボタンサイズ設定
        goLogin.backgroundColor = rgba // 背景色
        goLogin.layer.cornerRadius = 22.0 // 角丸のサイズ
        goLogin.setTitleColor(loginText, for: UIControlState.normal) // タイトルの色
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func goLoginButton(_ sender: Any) {
        //--------------------------------------- 移動
        self.performSegue(withIdentifier: "schedule", sender: nil)
//        let schedulePage = self.storyboard?.instantiateViewController(withIdentifier: "scheduleViewController") as! scheduleViewController
//        self.present(schedulePage, animated: true, completion: nil)
        //segueで繋いでいる理由は、視覚的にわかりやすくするため
        //--------------------------------------- 移動
    }
}
