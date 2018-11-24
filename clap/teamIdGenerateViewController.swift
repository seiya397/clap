import UIKit
import Firebase
import FirebaseDatabase


class teamIdGenerateViewController: UIViewController {

    @IBOutlet weak var generateTeamId: UILabel!
    @IBOutlet weak var goLogin: UIButton!
    
    var databaseRef:DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userdefaultToDisplay()
        ornement()
    }
    
    @IBAction func goLoginButton(_ sender: Any) {
        self.performSegue(withIdentifier: "schedule", sender: nil)
    }
}




extension teamIdGenerateViewController {
    func userdefaultToDisplay() {
        let userDefaults:UserDefaults = UserDefaults.standard
        let teamID: String = userDefaults.object(forKey: "teamID") as! String
        self.generateTeamId.text! = teamID
    }
    func ornement() {
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        goLogin.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        goLogin.backgroundColor = rgba
        goLogin.layer.cornerRadius = 22.0
        goLogin.setTitleColor(loginText, for: UIControlState.normal)
    }
}
