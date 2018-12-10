import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore
import SDWebImage

//データ型の指定
struct GroupData {
    var image: URL?
    var text: String?
    var userID: String?
}

class GroupViewController: UIViewController {
    
    //データベースの指定
    let db = Firestore.firestore()
    
    //Firebaseから取ってくるteamIDはString型
    var teamIDFromFirebase: String = ""
    //fireAuthUIDにユーザーのデータが入っているかの確認。入ってなければno dataとコンスト
    var fireAuthUID = (Auth.auth().currentUser?.uid ?? "no data")
    
    var userDefaults = UserDefaults.standard
    
    var groupData = [GroupData]()
    var groupImageArr = [Any]()
    var groupTextArr = [Any]()
    var groupUserIDArr = [Any]()
    var memberNewDiaryID = [Any]()
    
    @IBOutlet weak var memberCollection: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        basicInfo()
        navColor()
        getGroupData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        memberCollection.reloadData()
    }
    
    //メンバー追加ボタン
    @IBAction func memberAddButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "goMemberSelect", sender: nil)
    }
}




private extension GroupViewController {
    private func getGroupData() {
       
       //firebaseのusersからリアルタイムのアップデート情報を取得
    self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print(String(describing: error))
                return
            }
        //usersのteamIDの照合
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
       
       //firebaseのgroupから
        self.db.collection("group").document(self.teamIDFromFirebase).collection(self.fireAuthUID).getDocuments(completion: { (querySnapshot, err) in
                if err != nil {
                    print(String(describing: err))
                    return
                } else {
                    var i = 0
                    for document in querySnapshot!.documents {
                        guard var documentData: [String: Any] = document.data() else { return }
                        print(documentData)
                       
                       //プロフィール画像
                        self.groupImageArr.append((documentData["image"] as? String)!)
                        
                        //名前
                        self.groupTextArr.append((documentData["name"] as? String)!)
                        
                        //userIDの配置
                        self.groupUserIDArr.append((documentData["userID"] as? String)!)
                        
                        //if文でからなら定型文字 
                        self.groupData.append(GroupData(image: URL(
                            string: self.groupImageArr[i] as! String),
                            text: (self.groupTextArr[i] as! String),
                            userID: (self.groupUserIDArr[i] as! String)))
                        i += 1
                    }
                    self.memberCollection.reloadData()
                }
            })
        }
    }
    
    func getDiaryData(userID: String) {
       self.memberNewDiaryID = []
        self.db.collection("users").document(self.fireAuthUID).addSnapshotListener { (snapshot3, error) in
            guard let document3 = snapshot3 else {
                print(String(describing: error))
                return
            }
            guard let data = document3.data() else { return }
            self.teamIDFromFirebase = data["teamID"] as? String ?? ""
            let newSubmitDate = self.getNewSubmitDate()
           
            //firebaseのdiary-diariesの
            //userIDが一致してて、提出状況submitが提出trueされている状態で、日付dateがnewSubmitDate=getNewSubmitDateで取ってきた本日付けの日付のドキュメントを取ってくる。
            self.db.collection("diary").document(self.teamIDFromFirebase).collection("diaries").whereField("userID", isEqualTo: userID).whereField("submit", isEqualTo: true).whereField("date", isEqualTo: newSubmitDate).getDocuments(completion: { (query, err) in
                if err != nil {
                    return
                } else {
                    
                    //memberNewDiaryID
                    //新規日誌あがある場合 i = 0
                    //ない場合 i = 1  diaryID = NO DATA
                    var i = 0
                    for document in query!.documents {
                        guard var documentData: [String: Any] = document.data() else { return }
                        self.memberNewDiaryID.append(documentData["diaryID"] as? String ?? "NO DATA")
                        i += 1
                    }
                    //memberNewDiaryIDに値がない場合、
                    //MyDiaryDataを消して、"新着日誌はありません"のアラートを出す。
                    
                    self.userDefaults.removeObject(forKey: "MyDiaryData")
                    if self.memberNewDiaryID.isEmpty {
                        self.ShowMessage(messageToDisplay: "新着日記はありません。")
                        return
                    } else {
                        
                        //memberNewDiaryIDに値入っている場合(0,1)、
                        //MyDiaryDataを消して、memberNewDiaryIDに0をセットする。
                        self.userDefaults.removeObject(forKey: "MyDiaryData")
                        self.userDefaults.set(self.memberNewDiaryID[0], forKey: "MyDiaryData")
                        //値を即時反映させる
                        self.userDefaults.synchronize()
                        
                        //新規日誌提出画面への遷移設定
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubmitedNewDiaryViewController") as! SubmitedNewDiaryViewController
                        self.present(vc, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func getNewSubmitDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        let now = Date()
        return formatter.string(from: now)
    }
    
    //アラートの表示内容
    private func ShowMessage(messageToDisplay: String) {
        let alertController = UIAlertController(title: "新着日誌", message: messageToDisplay, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "閉じる", style: .default) { (action: UIAlertAction!) in
            print("ok button tapped!!")
        }
        
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //ナビゲーションの色指定
    func navColor() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 0/255, green: 82/255, blue: 212/255, alpha: 100)
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}




extension GroupViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func basicInfo() {
        self.view.backgroundColor = UIColor.white
        memberCollection.backgroundColor = UIColor.white
        let nibName = UINib(nibName: "memberCollectionViewCell", bundle: nil)
        memberCollection.register(nibName, forCellWithReuseIdentifier: "memberCell")
        memberCollection.delegate = self
        memberCollection.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupData.count
    }
    
    //メンバー追加画面(collectionView)
    //メンバーの写真、名前、userID、を取ってくる
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = memberCollection.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! memberCollectionViewCell
        let cellData = groupData[indexPath.row]
        cell.memberImage.sd_setImage(with: cellData.image)
        cell.memberTitle.text = cellData.text
        cell.userID.text = cellData.userID
        cell.groupDefaultColor()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellData = groupData[indexPath.row]
        
        let userID = cellData.userID
        
        self.getDiaryData(userID: userID!)
        
    }
    
    //collectionViewのサイズ指定
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.size.width / 4
        return CGSize(width: size, height: size)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let inset =  (self.view.frame.width / 4) / 5
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return (self.view.frame.width / 4) / 5
    }
}
