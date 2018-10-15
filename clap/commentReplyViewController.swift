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
    
    
    var replyUserNameArr = [String]()
    
    var replyUserTextArr = [String]()
    
    var replyUserTimeArr = [String]()
    
    
    @IBOutlet weak var commentedUserImage: UIImageView!
    
    @IBOutlet weak var commentedUserText: UITextView!
    
    @IBOutlet weak var replyUserTable: UITableView!
    
    @IBOutlet weak var replyUserImage: UIImageView!
    
    @IBOutlet weak var replyUserText: UITextView!
    
    @IBOutlet weak var replyUserButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let userDefaults: UserDefaults = UserDefaults.standard
        
        timeline = (userDefaults.string(forKey: "goTimeline") ?? "nodata")
        
        commentID = (userDefaults.string(forKey: "goReply") ?? "nodata")
        
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
                    
                    self.commentedUserText.text = data!["text"] as? String ?? "noTextData"
                }
            }
        }
        
        self.db.collection("users").document(fireAuthUID).getDocument { (document, error) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                self.teamID = String(describing: document["teamID"]!)
                self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("reply").getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        for document in querySnapshot!.documents {
                            
                            print("成功成功成功成功成功\(document.documentID) => \(document.data())")
                            
                            let documentData = document.data()
                            
                            self.replyUserNameArr.append((documentData["name"] as? String)!)
                            self.replyUserTextArr.append((documentData["text"] as? String)!)
                            
                            self.replyUserTimeArr.append((documentData["update_at"] as? String)!)
                            
                        }
                        self.replyUserTable.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        let nibName = UINib(nibName: "replyTableViewCell", bundle: nil)
        
        replyUserTable.register(nibName, forCellReuseIdentifier: "replyTableViewCell")
        
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        let now = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let submitOrReplyTime = formatter.string(from: now as Date)
        
        
        let replyRandomNum = self.randomString(length: 20)
        
        let replyData = ["id": replyRandomNum,"commonID": self.commentID,  "userID": self.fireAuthUID, "text": self.replyUserText.text!, "name": self.userName, "update_at": submitOrReplyTime] as [String : Any]
        
        db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("reply").document(replyRandomNum).setData(replyData) {
            err in
            if err != nil {
                print("replyの追加に失敗しました")
                return
            } else {
                print("replyの追加に成功")
                self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("reply").document(replyRandomNum).addSnapshotListener { (snapshot, error) in
                    guard let document = snapshot else {
                        print("erorr2 \(String(describing: error))")
                        return
                    }
                    
                    let data = document.data()
                    
                    let textDataFromFirebase = (data!["text"] as? String)!
                    
                    let nameDataFromFirebase = (data!["name"] as? String)!
                    
                    let timeDataFromFirebase = (data!["update_at"] as? String)!
                    
                    self.replyUserTextArr.append(textDataFromFirebase)
                    
                    self.replyUserNameArr.append(nameDataFromFirebase)
                    
                    self.replyUserTimeArr.append(timeDataFromFirebase)
                    
                    self.replyUserTable.reloadData()
                }
            }
        }
    }
    
    func randomString(length: Int) -> String {  //ランダムID
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
}

extension commentReplyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return replyUserTextArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = replyUserTable.dequeueReusableCell(withIdentifier: "replyTableViewCell", for: indexPath) as! replyTableViewCell
        cell.commentInit(name: replyUserNameArr[indexPath.item], text: replyUserTextArr[indexPath.item], time: replyUserTimeArr[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}




