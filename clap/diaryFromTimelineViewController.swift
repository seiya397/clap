import UIKit
import Firebase
import FirebaseFirestore

class diaryFromTimelineViewController: UIViewController {
    
    let db = Firestore.firestore()
    
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var teamID = String()
    
    var timeline = String()
    
    var dataFromFireStore1 = [Any]()
    var dataFromFireStore2 = [Any]()
    var dataFromFireStore3 = [Any]()
    var dataFromFireStore4 = [Any]()
    var dataFromFireStore5 = [Any]()
    var dataFromFireStore6 = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userDefaults: UserDefaults = UserDefaults.standard
        timeline = (userDefaults.object(forKey: "goTimeline")! as? String)!
        
        
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
                        print("aaaaaaaaaaaaaaaaaaaaaaa")
                        print(data as Any)
                    self.dataFromFireStore1.append((data!["こんな練習してみたい"] as? String)!)
                    self.dataFromFireStore2.append((data!["ここが良かった！今日の自分"] as? String)!)
                    self.dataFromFireStore3.append((data!["監督へのメッセージ"] as? String)!)
                    self.dataFromFireStore4.append((data!["考えました明日の課題"] as? String)!)
                    self.dataFromFireStore5.append((data!["メンバーのここを褒めたい"] as? String)!)
                    self.dataFromFireStore6.append((data!["今日のタイトル"] as? String)!)
                    print("======================")
                    print(self.dataFromFireStore1)
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
}
