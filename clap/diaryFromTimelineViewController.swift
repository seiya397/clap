import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth
import Foundation
import SDWebImage

class diaryFromTimelineViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let db = Firestore.firestore()
    
    let fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var teamID = String()
    
    var timeline = String()
    
    var userNameFromFirebase = String()
    
    
    var commentUserTextArr = [String]()
    
    var commentUserNameArr = [String]()
    
    var commentUserTimeArr = [String]()
    
    var commentUserImageArr = [String]()
    
    var commentIdArr = [String]()
    
    var commentedUserName = String()
    
    var commentUserImageToFireStore = String()
    
    var userName = String()
    
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
    
    
    
    @IBOutlet weak var commentUserCount: UILabel!
    @IBOutlet weak var commentUserImage: UIImageView!
    @IBOutlet weak var commentUserTextfield: UITextView!
    @IBOutlet weak var commentUserTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView.backgroundColor = UIColor.white
        
        textView1.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView2.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView3.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView4.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView5.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        textView6.addBorderBottom(height: 1.0, color: UIColor.lightGray)
        
        textView1.isEditable = false
        textView2.isEditable = false
        textView3.isEditable = false
        textView4.isEditable = false
        textView5.isEditable = false
        textView6.isEditable = false
        
        textLabel1.text = "今日のタイトル"
        textLabel2.text = "ここが良かった！今日の自分"
        textLabel3.text = "監督へのメッセージ"
        textLabel4.text = "考えました明日の課題"
        textLabel5.text = "メンバーのここを褒めたい"
        textLabel6.text = "こんな練習してみたい"
        
        let userDefaults: UserDefaults = UserDefaults.standard
        timeline = (userDefaults.string(forKey: "goTimeline") ?? "nodata")
        
        self.db.collection("users").document(fireAuthUID).getDocument { (document, error) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                self.teamID = String(describing: document["teamID"]!)
                self.commentedUserName = String(describing: document["name"]!)
                let userURL = URL(string: document["image"] as! String)
                self.commentUserImage.sd_setImage(with: userURL)
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
        
        //コメント表示
        
        self.db.collection("users").document(fireAuthUID).getDocument { (document, error) in
            if let document = document, document.exists {
                _ = document.data().map(String.init(describing:)) ?? "nil"
                self.teamID = String(describing: document["teamID"]!)
                self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("comment").whereField("edited", isEqualTo: false).getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        return
                    } else {
                        var i = 0
                        for document in querySnapshot!.documents {

                            
                            print("成功成功成功成功成功\(document.documentID) => \(document.data())")
                            
                            self.commentIdArr.append(document.documentID)
                            
                            guard let documentData: [String: Any] = document.data() else { return }
                            
                            self.commentUserNameArr.append(documentData["name"] as? String ?? "")
                            self.commentUserTextArr.append(documentData["text"] as? String ?? "")
                            
                            self.commentUserImageArr.append(documentData["image"] as? String ?? "")
                            self.commentUserTimeArr.append(documentData["update_at"] as? String ?? "")
                            
                            i += 1
                        }
                        self.commentUserCount.text = "コメント数 \(i)"
                        self.commentUserTableView.reloadData()
                    }
                }
            } else {
                print("Document does not exist")
            }
        }

        //コメント機能
        commentUserTableView.delegate = self
        commentUserTableView.dataSource = self
        
        let nibName = UINib(nibName: "commentTableViewCell", bundle: nil)
        
        commentUserTableView.register(nibName, forCellReuseIdentifier: "commentTableViewCell")
        
        //ユーザーの名前取得
        db.collection("users").document(fireAuthUID).addSnapshotListener { (snapshot2, error) in
            guard let document2 = snapshot2 else {
                print("erorr2 \(String(describing: error))")
                return
            }
            let data = document2.data()
            
            self.userName = (data!["name"] as? String)!
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func commentUserButtonTapped(_ sender: Any) {
        //submit or 保存ボタン押した時の時刻取得
        let now = NSDate()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        
        let submitOrReplyTime = formatter.string(from: now as Date)
        
        
        let commentRandomNum = self.randomString(length: 20)
        
        db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot, err) in
            guard let document = snapshot else {
                print("erorr \(String(describing: err))")
                return
            }
            
            guard let data = document.data() else { return }
            self.commentUserImageToFireStore = data["image"] as? String ?? ""
            
            let commentData = ["id": commentRandomNum, "userID": self.fireAuthUID, "text": self.commentUserTextfield.text!, "edited": false, "name": self.userName, "update_at": submitOrReplyTime, "image": self.commentUserImageToFireStore] as [String : Any]
            self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("comment").document(commentRandomNum).setData(commentData) {
                err in
                if err != nil {
                    print("コメントの追加に失敗しました")
                    return
                } else {
                    print("コメントの追加に成功")
                    self.db.collection("diary").document(self.teamID).collection("diaries").document(self.timeline).collection("comment").document(commentRandomNum).addSnapshotListener { (snapshot3, error) in
                        guard let document3 = snapshot3 else {
                            print("erorr2 \(String(describing: error))")
                            return
                        }
                        
                        guard let data = document3.data() else { return }
                        
                        let textDataFromFirebase = data["text"] as? String ?? ""
                        
                        let nameDataFromFirebase = data["name"] as? String ?? ""
                        
                        let timeDataFromFirebase = data["update_at"] as? String ?? ""
                        
                        let commentIdFromFirebase = data["id"] as? String ?? ""
                        
                        let commentImageFromFirebase = data["image"] as? String ?? ""
                        
                        self.commentUserTextArr.append(textDataFromFirebase)
                        
                        self.commentUserNameArr.append(nameDataFromFirebase)
                        
                        self.commentUserTimeArr.append(timeDataFromFirebase)
                        
                        self.commentUserImageArr.append(commentImageFromFirebase)
                        
                        self.commentIdArr.append(commentIdFromFirebase)
                        
                        self.commentUserTableView.reloadData()
                    }
                }
            }
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentUserTextArr.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentUserTableView.dequeueReusableCell(withIdentifier: "commentTableViewCell", for: indexPath) as! commentTableViewCell
        
        cell.commentInit(image: URL(string: commentUserImageArr[indexPath.item]),name: commentUserNameArr[indexPath.item], text: commentUserTextArr[indexPath.item], time: commentUserTimeArr[indexPath.item])
        cell.delegate = self
        cell.commentID = indexPath.item
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
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

extension diaryFromTimelineViewController: CommentTableViewCellDelegate {
    func didButtonPressed(commentID: Int) {
        
        let userDefaults:UserDefaults = UserDefaults.standard
        
        userDefaults.removeObject(forKey: "goReply")
        
        userDefaults.set(self.commentIdArr[commentID], forKey: "goReply")
        
        userDefaults.synchronize()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "commentReplyViewController") as! commentReplyViewController
        
            self.present(vc, animated: true, completion: nil)
    }
}
