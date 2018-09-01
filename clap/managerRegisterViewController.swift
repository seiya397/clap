import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class managerRegisterViewController: UIViewController {
    
    @IBOutlet weak var managerRegisterMailaddress: UITextField!
    @IBOutlet weak var managerRegisterPassword: UITextField!
    @IBOutlet weak var oneMorePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func managerRegisterNextButton(_ sender: Any) {
        guard let managerRegisterMailText = managerRegisterMailaddress.text, !managerRegisterMailText.isEmpty else {
            self.ShowMessage(messageToDisplay: "メールアドレスを記入してください。")
            return
        }
        guard let managerRegisterPassText = managerRegisterPassword.text, !managerRegisterPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "パスワードを記入してください。")
            return
        }
        guard let oneMoreManagerRegisterPassText = oneMorePassword.text, !oneMoreManagerRegisterPassText.isEmpty else {
            self.ShowMessage(messageToDisplay: "確認用パスワードを記入してください。")
            return
        }
        if managerRegisterPassText != oneMoreManagerRegisterPassText {
            self.ShowMessage(messageToDisplay: "パスワードが合致しません。")
            return
        }
        Auth.auth().createUser(withEmail: managerRegisterMailText, password: managerRegisterPassText) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.ShowMessage(messageToDisplay: error.localizedDescription)
                return
            }
            if let user = user {
                var databaseReference: DatabaseReference!
                databaseReference = Database.database().reference()
                
                
                
                print("success")
                self.performSegue(withIdentifier: "goTeamRegister", sender: nil)
                
                
            }
        }
     }
    
    
    @IBAction func cancelRegisterButton(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
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
