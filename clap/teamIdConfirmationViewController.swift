import UIKit
import FirebaseFirestore
import FirebaseAuth


class teamIdConfirmationViewController: UIViewController {

    @IBOutlet weak var confirmTeamID: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func confirmTreamIdButtonTapped(_ sender: Any) {
        guard let confirmText = confirmTeamID.text, !confirmText.isEmpty else {
            self.ShowMessage(messageToDisplay: "チームIDを記入してください。")
            return
        }
        let docRef = db.collection("teams").document(confirmTeamID.text!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("成功した場合\(document)")
                let againConfirm = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmAgainViewController") as! teamIdConfirmAgainViewController
                self.present(againConfirm, animated: true, completion: nil)
            } else {
                print("失敗した場合\(error)")
                let wrongConfirm = self.storyboard?.instantiateViewController(withIdentifier: "teamIdConfirmWrongViewController") as! teamIdConfirmWrongViewController
                self.present(wrongConfirm, animated: true, completion: nil)
                
            }
        }
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
