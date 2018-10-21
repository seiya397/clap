import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class diarySubmitViewController: UIViewController {

    let db = Firestore.firestore()
    
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var teamID = String()
    
    var timeline = String()
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var textLabel1: UILabel!
    @IBOutlet weak var textView1: UITextView!
    
    @IBOutlet weak var textLabel2: UILabel!
    @IBOutlet weak var textView2: UITextView!
    
    @IBOutlet weak var textLabel3: UILabel!
    @IBOutlet weak var textView3: UITextView!
    
    @IBOutlet weak var textLabel4: UILabel!
    @IBOutlet weak var textView4: UITextView!
    
    @IBOutlet weak var textLabel5: UILabel!
    @IBOutlet weak var textView5: UITextView!
    
    @IBOutlet weak var textLabel6: UILabel!
    @IBOutlet weak var textView6: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor.white
        
        
        textLabel1.text = "今日のタイトル"
        textLabel2.text = "ここが良かった！今日の自分"
        textLabel3.text = "監督へのメッセージ"
        textLabel4.text = "考えました明日の課題"
        textLabel5.text = "メンバーのここを褒めたい"
        textLabel6.text = "こんな練習してみたい"
        
        let userDefaults: UserDefaults = UserDefaults.standard
        timeline = (userDefaults.object(forKey: "goSubmit")! as? String)!
        
        
        self.db.collection("users").document(fireAuthUID).getDocument { (document, error) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                self.teamID = String(describing: document["teamID"]!)
                self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).addSnapshotListener { (snapshot, error) in
                    guard let document = snapshot else {
                        print("erorr2 \(String(describing: error))")
                        return
                    }
                    let data = document.data()
                    self.textView1.text = (data!["今日のタイトル"] as? String)!
                    self.textView2.text = (data!["ここが良かった！今日の自分"] as? String)!
                    self.textView3.text = (data!["監督へのメッセージ"] as? String)!
                    self.textView4.text = (data!["メンバーのここを褒めたい"] as? String)!
                    self.textView5.text = (data!["考えました明日の課題"] as? String)!
                    self.textView6.text = (data!["こんな練習してみたい"] as? String)!
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
