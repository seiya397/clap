import UIKit
import Firebase
import FirebaseDatabase

class teamIdGenerateViewController: UIViewController {

    @IBOutlet weak var generateTeamId: UILabel!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = userDefaults.object(forKey: "teamID") as! String
        self.generateTeamId.text! = teamID
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
