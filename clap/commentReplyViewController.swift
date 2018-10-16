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
    
    
    var replyUserImageToFirebase = String()
    
    var replyUserNameArr = [String]()
    
    var replyUserTextArr = [String]()
    
    var replyUserTimeArr = [String]()
    
    var replyUserImageArr = [String]()
    
    
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
                let myImageURL = URL(string: document["image"] as! String)
                self.replyUserImage.sd_setImage(with: myImageURL)
                self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("comment").document(self.commentID).addSnapshotListener { (snapshot, error) in
                    guard let document = snapshot else {
                        print("erorr2 \(String(describing: error))")
                        return
                    }
                    guard let data = document.data() else { return }
                    
                    self.commentedUserText.text = data["text"] as? String ?? "noTextData"
                    let commnetUserImageURL = URL(string: data["image"] as? String ?? "")
                    self.commentedUserImage.sd_setImage(with: commnetUserImageURL)
                }
            }
        }
        //reply表示
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
                            
                            self.replyUserImageArr.append((documentData["image"] as? String)!)

                        }
                        self.replyUserTable.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
        
        //コメント機能
        replyUserTable.delegate = self
        replyUserTable.dataSource = self
        
        let nibName = UINib(nibName: "replyTableViewCell", bundle: nil)
        
        replyUserTable.register(nibName, forCellReuseIdentifier: "replyTableViewCell")
        
        
    }
    
    @IBAction func replyButtonTapped(_ sender: Any) {
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot, error) in
            guard let document = snapshot else {
                print("erorr2 \(String(describing: error))")
                return
            }
            guard let data = document.data() else { return }
            self.replyUserImageToFirebase = data["image"] as? String ?? ""
            
            let now = NSDate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            
            let submitOrReplyTime = formatter.string(from: now as Date)
            
            
            let replyRandomNum = self.randomString(length: 20)
        
        
            let replyData = ["id": replyRandomNum,"commonID": self.commentID,  "userID": self.fireAuthUID, "text": self.replyUserText.text!, "name": self.userName, "update_at": submitOrReplyTime, "image": self.replyUserImageToFirebase] as [String : Any]
            
            self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("reply").document(replyRandomNum).setData(replyData) {
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
                        
                        guard let data = document.data() else { return }
                        
                        let textDataFromFirebase = data["text"] as? String ?? ""
                        
                        let nameDataFromFirebase = data["name"] as? String ?? ""
                        
                        let timeDataFromFirebase = data["update_at"] as? String ?? ""
                        
                        let imageDataFromFirebase = data["image"] as? String ?? ""
                        
                        self.replyUserTextArr.append(textDataFromFirebase)
                        
                        self.replyUserNameArr.append(nameDataFromFirebase)
                        
                        self.replyUserTimeArr.append(timeDataFromFirebase)
                        
                        self.replyUserImageArr.append(imageDataFromFirebase)
                        
                        self.replyUserTable.reloadData()
                    }
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
        cell.commentInit(image: URL(string: replyUserImageArr[indexPath.item]),name: replyUserNameArr[indexPath.item], text: replyUserTextArr[indexPath.item], time: replyUserTimeArr[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}




