import UIKit
import FirebaseFirestore

class teamIdConfirmAgainViewController: UIViewController {

    @IBOutlet weak var displayTeamName: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayBelong()
        ornement()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        userInfoRegisterPage()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        loginPage()
    }
}




extension teamIdConfirmAgainViewController {
    func ornement() {
        let rgba = UIColor(red: 255/255, green: 189/255, blue: 0/255, alpha: 1.0)
        let loginText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        confirmButton.frame = CGRect(x: 0, y: 0, width: 0, height: 46)
        confirmButton.backgroundColor = rgba
        confirmButton.layer.cornerRadius = 20.0
        confirmButton.setTitleColor(loginText, for: UIControlState.normal)
    }
    
    func displayBelong() {
        let userDefaults: UserDefaults = UserDefaults.standard
        let teamID: String = (userDefaults.object(forKey: "teamID")! as? String)!
        
        db.collection("teams").document(teamID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                return
            }
            let data = document.data()
            self.displayTeamName.text = data!["belong"] as? String
        }
    }
    
    func userInfoRegisterPage() {
        let userInfoRegisterPage2 = self.storyboard?.instantiateViewController(withIdentifier: "userInfoRegisterViewController") as! userInfoRegisterViewController
        self.present(userInfoRegisterPage2, animated: true, completion: nil)
    }
    
    func loginPage() {
        let loginPage2 = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage2, animated: true, completion: nil)
    }
}
