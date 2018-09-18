import UIKit
import FirebaseFirestore
import FirebaseAuth

class myPageViewController: UIViewController {
    
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
        print("今度こそ\(fireAuthUID)")
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
        } catch {
            print("ログアウトできませんでした")
        }
        
    }
    
}

