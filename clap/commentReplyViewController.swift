import UIKit
import Firebase
import FirebaseFirestore

class commentReplyViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")//画像取得のため,teamID取得のため
    
    var teamID = String()
    
    var userName = String()
    
    var commentID = String()
    
    var timeline = String()
    
    
    @IBOutlet weak var commentedUserImage: UIImageView!
    
    @IBOutlet weak var commentedUserText: UITextView!
    
    @IBOutlet weak var replyUserTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults: UserDefaults = UserDefaults.standard
        
        timeline = (userDefaults.string(forKey: "goTimeline") ?? "nodata")
        
        commentID = (userDefaults.string(forKey: "goReply") ?? "nodata")
        
        //idでその階層,textで文章、
        self.db.collection("users").document(fireAuthUID).getDocument { (document, error) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                self.teamID = String(describing: document["teamID"]!)
                self.userName = String(describing: document["name"]!)
                self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("comment").document(self.commentID).addSnapshotListener { (snapshot, error) in
                    guard let document = snapshot else {
                        print("erorr2 \(String(describing: error))")
                        return
                    }
                    let data = document.data()
                    
                    self.commentedUserText.text = data!["text"] as? String ?? "notextdata"
                    
                    
                    
                }
            }
        }
    }
    
}




